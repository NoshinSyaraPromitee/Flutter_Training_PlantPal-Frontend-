import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'failure.dart';
import 'sse_client_factory.dart';

/// One Server-Sent Event: its `event:` name and joined `data:` payload.
class SseEvent {
  const SseEvent(this.event, this.data);
  final String event;
  final String data;
}

/// A POST request whose response is read as a live Server-Sent Events
/// stream.
///
/// Dio cannot deliver a response body incrementally on Flutter web, so this
/// uses `package:http`, with a fetch-based client on web (see
/// sse_client_factory.dart) and the normal socket client everywhere else.
/// Both hand over bytes as they arrive.
class SseConnection {
  SseConnection._(this._client, this.events);

  final http.Client _client;

  /// Parsed events. HTTP errors (non-200) arrive as a [Failure] error.
  /// Cancelling via [cancel] ends the stream without an error.
  final Stream<SseEvent> events;

  bool _cancelled = false;

  /// Aborts the request; the server sees the disconnect immediately.
  void cancel() {
    if (_cancelled) return;
    _cancelled = true;
    _client.close();
  }

  static SseConnection post(
    Uri url, {
    required Map<String, String> headers,
    required Object body,
    void Function()? onUnauthorized,
  }) {
    final client = createStreamingClient();
    final controller = StreamController<SseEvent>();
    final connection = SseConnection._(client, controller.stream);

    () async {
      try {
        final request = http.Request('POST', url)
          ..headers.addAll({
            ...headers,
            'Content-Type': 'application/json',
            'Accept': 'text/event-stream',
          })
          ..body = jsonEncode(body);

        // The server answers only once the first text exists, which can take
        // a while when the AI provider is slow to start.
        final response = await client
            .send(request)
            .timeout(const Duration(seconds: 60));

        if (response.statusCode != 200) {
          final raw = await response.stream.bytesToString();
          if (response.statusCode == 401) onUnauthorized?.call();
          throw Failure(
            _serverMessage(raw) ?? 'HTTP ${response.statusCode}',
            statusCode: response.statusCode,
          );
        }

        var event = 'message';
        final data = <String>[];
        void dispatch() {
          if (data.isNotEmpty) controller.add(SseEvent(event, data.join('\n')));
          event = 'message';
          data.clear();
        }

        // utf8.decoder on a byte stream is chunk-safe: a multi-byte
        // character (Bengali!) split across packets is not corrupted.
        final lines = response.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter());
        await for (final line in lines) {
          if (line.isEmpty) {
            dispatch();
          } else if (line.startsWith(':')) {
            // comment / keep-alive
          } else if (line.startsWith('event:')) {
            event = line.substring(6).trim();
          } else if (line.startsWith('data:')) {
            final v = line.substring(5);
            data.add(v.startsWith(' ') ? v.substring(1) : v);
          }
        }
        dispatch(); // stream may end without a trailing blank line
      } catch (e, st) {
        // Closing the client on purpose surfaces as an exception here;
        // that is a normal end, not an error.
        if (!connection._cancelled) controller.addError(e, st);
      } finally {
        client.close();
        await controller.close();
      }
    }();

    return connection;
  }

  static String? _serverMessage(String raw) {
    try {
      final j = jsonDecode(raw);
      if (j is Map && j['error'] != null) return j['error'].toString();
    } catch (_) {}
    return null;
  }
}
