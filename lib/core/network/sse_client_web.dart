import 'package:fetch_client/fetch_client.dart';
import 'package:http/http.dart' as http;

/// Web: XHR (the default client) buffers the whole response, so use the
/// Fetch API, which exposes the body as a stream.
http.Client createStreamingClient() => FetchClient(mode: RequestMode.cors);
