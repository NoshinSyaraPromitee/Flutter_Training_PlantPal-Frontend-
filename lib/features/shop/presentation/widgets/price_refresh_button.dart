import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/repositories/price_refresh_repository.dart';
import '../../domain/model/product.dart';
import '../../../../l10n/app_localizations.dart';

/// Shows the catalog price + an on-demand AI "Refresh Price" button.
/// The refresh calls the backend which queries Groq Compound web search,
/// caching the result server-side for 6 hours.
class PriceRefreshButton extends StatefulWidget {
  const PriceRefreshButton({
    super.key,
    required this.product,
    required this.repository,
  });

  final Product product;
  final PriceRefreshRepository repository;

  @override
  State<PriceRefreshButton> createState() => _PriceRefreshButtonState();
}

class _PriceRefreshButtonState extends State<PriceRefreshButton> {
  bool _loading = false;
  PriceRefreshResult? _result;
  String? _error;

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final r = await widget.repository.refresh(widget.product.id);
      setState(() => _result = r);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fmt = NumberFormat('#,##0', 'en');

    if (_loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
          const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.greenPrimary)),
          const SizedBox(width: 10),
          Text(l10n.checkingPriceLabel, style: AppTextStyles.inter(13, c: AppColors.textMuted)),
        ]),
      );
    }

    if (_result != null) {
      final priceStr = '৳${fmt.format(_result!.priceBdt.round())}';
      final timeAgo = _timeAgo(_result!.asOf, l10n);
      return Container(
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceGreen,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.greenPrimary.withValues(alpha: 0.3)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
            const Icon(Icons.verified, size: 16, color: AppColors.greenPrimary),
            const SizedBox(width: 6),
            Text(l10n.aiPriceRefreshedLabel, style: AppTextStyles.inter(12, c: AppColors.greenPrimary, w: FontWeight.w700)),
          ]),
          const SizedBox(height: 4),
          Text(priceStr, style: AppTextStyles.inter(22, w: FontWeight.w800, c: const Color(0xFFFF9800))),
          const SizedBox(height: 2),
          Text(
            l10n.priceCheckedAgoLabel(timeAgo),
            style: AppTextStyles.inter(11, c: AppColors.textMuted),
          ),
          if (_result!.note != null && _result!.note!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(_result!.note!, style: AppTextStyles.inter(11, c: AppColors.textMuted)),
          ],
          if (!_result!.inStock)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(l10n.possiblyOutOfStockLabel, style: AppTextStyles.inter(12, c: AppColors.danger, w: FontWeight.w600)),
            ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _refresh,
            child: Text(l10n.refreshAgainLabel, style: AppTextStyles.inter(12, c: AppColors.greenPrimary, w: FontWeight.w700)),
          ),
        ]),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          const Icon(Icons.wifi_off, size: 16, color: AppColors.danger),
          const SizedBox(width: 6),
          Expanded(child: Text(l10n.priceRefreshFailedLabel, style: AppTextStyles.inter(12, c: AppColors.danger))),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _refresh,
            child: Text(l10n.retryLabel, style: AppTextStyles.inter(12, c: AppColors.greenPrimary, w: FontWeight.w700)),
          ),
        ]),
      );
    }

    // Default: show the refresh button
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.greenPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: _refresh,
      icon: const Icon(Icons.refresh, size: 16, color: AppColors.greenPrimary),
      label: Text(l10n.refreshPriceButton, style: AppTextStyles.inter(13, c: AppColors.greenPrimary, w: FontWeight.w600)),
    );
  }

  String _timeAgo(DateTime t, AppLocalizations l10n) {
    final diff = DateTime.now().difference(t);
    if (diff.inSeconds < 60) return l10n.justNowLabel;
    if (diff.inMinutes < 60) return l10n.minutesAgoLabel(diff.inMinutes);
    return l10n.hoursAgoLabel(diff.inHours);
  }
}
