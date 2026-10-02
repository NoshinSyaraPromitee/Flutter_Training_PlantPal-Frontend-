// Picks the HTTP client that can read a response body incrementally:
// a fetch-based one in the browser, the regular socket client elsewhere.
export 'sse_client_io.dart' if (dart.library.js_interop) 'sse_client_web.dart';
