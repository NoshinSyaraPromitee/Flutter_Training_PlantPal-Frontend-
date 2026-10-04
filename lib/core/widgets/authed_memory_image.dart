import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantpal/app/riverpod_providers.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/l10n/app_localizations.dart';

/// An image that is only served to the signed-in user (a scan photo).
///
/// Image.network / NetImage cannot send the Bearer token, so the bytes are
/// fetched through [ApiClient] (cached in memory there) and drawn with
/// Image.memory. Shows a spinner while loading and a tap-to-retry
/// placeholder when the photo is gone or the request fails.
class AuthedMemoryImage extends ConsumerStatefulWidget {
  const AuthedMemoryImage(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.radius = 12,
    this.fit = BoxFit.cover,
  });

  /// API path such as `/api/v1/diagnoses/{id}/image`.
  final String path;
  final double? width;
  final double? height;
  final double radius;
  final BoxFit fit;

  @override
  ConsumerState<AuthedMemoryImage> createState() => _AuthedMemoryImageState();
}

class _AuthedMemoryImageState extends ConsumerState<AuthedMemoryImage> {
  late Future<Uint8List> _bytes;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(AuthedMemoryImage old) {
    super.didUpdateWidget(old);
    if (old.path != widget.path) _load();
  }

  void _load() => _bytes = ref.read(apiClientProvider).fetchBytes(widget.path);

  Widget _box(Widget child) => Container(
        width: widget.width,
        height: widget.height,
        color: AppColors.greenPrimary.withValues(alpha: 0.08),
        alignment: Alignment.center,
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: FutureBuilder<Uint8List>(
        future: _bytes,
        builder: (context, snap) {
          if (snap.hasData) {
            return Image.memory(
              snap.data!,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => _failed(context),
            );
          }
          if (snap.hasError) return _failed(context);
          return _box(
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.greenPrimary,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _failed(BuildContext context) => GestureDetector(
        onTap: () => setState(_load),
        child: _box(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.broken_image_outlined, color: AppColors.greenPrimary),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context).chatPhotoUnavailable,
                textAlign: TextAlign.center,
                style: AppTextStyles.inter(11, c: AppColors.textMuted),
              ),
            ],
          ),
        ),
      );
}
