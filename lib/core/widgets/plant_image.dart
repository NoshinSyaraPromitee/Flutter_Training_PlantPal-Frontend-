import 'package:flutter/material.dart';
import 'authed_memory_image.dart';
import 'net_image.dart';

/// Smart image widget for plant photos.
///
/// The backend stores plant images behind auth-protected API paths like
/// `/api/v1/plants/{id}/image`. These need the Bearer token, which
/// [Image.network] / [NetImage] can't provide.
///
/// This widget checks whether [url] looks like an API path (starts with `/`)
/// and routes to [AuthedMemoryImage] (which fetches via [ApiClient] with the
/// token), or falls back to [NetImage] for full URLs / empty strings.
class PlantImage extends StatelessWidget {
  const PlantImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.radius = 16,
    this.fit = BoxFit.cover,
  });

  final String url;
  final double? width;
  final double? height;
  final double radius;
  final BoxFit fit;

  /// True when the URL is a server API path that requires auth headers.
  bool get _isApiPath => url.startsWith('/api/');

  @override
  Widget build(BuildContext context) {
    if (url.isNotEmpty && _isApiPath) {
      return AuthedMemoryImage(
        url,
        width: width,
        height: height,
        radius: radius,
        fit: fit,
      );
    }
    return NetImage(
      url,
      width: width,
      height: height,
      radius: radius,
      fit: fit,
    );
  }
}
