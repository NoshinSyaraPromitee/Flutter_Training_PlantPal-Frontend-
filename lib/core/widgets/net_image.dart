import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// An image with a themed placeholder/error fallback, used for shop product
/// photos. Accepts either a remote URL or a bundled `assets/...` path.
class NetImage extends StatelessWidget {
  const NetImage(
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

  Widget _box(Widget child) => Container(
        width: width,
        height: height,
        color: AppColors.greenPrimary.withValues(alpha: 0.08),
        alignment: Alignment.center,
        child: child,
      );

  Widget _placeholder() =>
      _box(const Icon(Icons.local_florist, color: AppColors.greenPrimary));

  // Bundled photos (see core/data/local_product_images.dart) are passed in
  // as "assets/..." paths rather than URLs, so route those through
  // Image.asset instead of hitting the network at all.
  bool get _isAsset => url.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: url.isEmpty
          ? _placeholder()
          : _isAsset
              ? Image.asset(
                  url,
                  width: width,
                  height: height,
                  fit: fit,
                  errorBuilder: (_, _, _) => _placeholder(),
                )
              : Image.network(
                  url,
                  width: width,
                  height: height,
                  fit: fit,
                  errorBuilder: (_, _, _) => _placeholder(),
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : _box(
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                ),
    );
  }
}