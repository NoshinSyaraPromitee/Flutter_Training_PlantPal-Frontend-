import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/app_localizations.dart';

class ReviewsSection extends ConsumerStatefulWidget {
  const ReviewsSection({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  ConsumerState<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends ConsumerState<ReviewsSection> {
  int _rating = 0;
  final _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _rating > 0 && _comment.text.trim().isNotEmpty;

  Future<void> _submit() async {
    await ref.read(reviewsControllerProvider).add(
          widget.productId,
          rating: _rating,
          comment: _comment.text,
        );

    if (!mounted) return;

    setState(() {
      _rating = 0;
      _comment.clear();
    });
  }

  Widget _stars(
    int value, {
    double size = 14,
    ValueChanged<int>? onTap,
  }) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var s = 1; s <= 5; s++)
            GestureDetector(
              onTap: onTap == null ? null : () => onTap(s),
              child: Icon(
                s <= value
                    ? Icons.star
                    : Icons.star_border,
                size: size,
                color: AppColors.star,
              ),
            ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = ref.watch(reviewsControllerProvider);
    final list = c.of(widget.productId);
    final avg = c.average(widget.productId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          l10n.reviewsSectionTitle,
          trailing: avg == null
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: AppColors.star,
                    ),
                    Text(
                      ' ${avg.toStringAsFixed(1)} · ${list.length}',
                      style: AppTextStyles.inter(
                        13,
                        w: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
        if (list.isEmpty)
          Text(
            l10n.noReviewsMessage,
            style: AppTextStyles.inter(
              13,
              c: AppColors.textMuted,
            ),
          ),
        for (final r in list)
          AppCard(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.greenPrimary,
                      child: Text(
                        r.name[0].toUpperCase(),
                        style: AppTextStyles.inter(
                          13,
                          w: FontWeight.w700,
                          c: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.name,
                            style: AppTextStyles.inter(
                              14,
                              w: FontWeight.w700,
                            ),
                          ),
                          Text(
                            r.date,
                            style: AppTextStyles.inter(
                              11,
                              c: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _stars(r.rating),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  r.comment,
                  style: AppTextStyles.inter(
                    13,
                    h: 1.4,
                  ),
                ),
              ],
            ),
          ),
        SectionTitle(l10n.writeReviewTitle),
        AppCard(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                l10n.yourRatingLabel,
                style: AppTextStyles.inter(
                  13,
                  w: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              _stars(
                _rating,
                size: 30,
                onTap: (v) =>
                    setState(() => _rating = v),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _comment,
                maxLines: 3,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: l10n.reviewHintText,
                  filled: true,
                  fillColor:
                      const Color(0xFFF6F6F6),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        AppColors.greenPrimary,
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),
                  onPressed:
                      _canSubmit ? _submit : null,
                  child: Text(
                    l10n.submitReviewButton,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}