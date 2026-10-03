import 'package:http/http.dart' as http;

/// Mobile / desktop: the default client already streams response bodies.
http.Client createStreamingClient() => http.Client();
