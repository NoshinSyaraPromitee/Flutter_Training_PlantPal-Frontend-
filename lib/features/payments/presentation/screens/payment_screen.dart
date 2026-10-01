import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/payment_models.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({
    super.key,
    required this.total,
    required this.eta,
  });

  final double total;
  final String eta;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  PaymentMethod _method = PaymentMethod.all.first;

  static const _icons = {
    'card': Icons.credit_card,
    'bkash': Icons.phone_android,
    'nagad': Icons.account_balance_wallet_outlined,
    'cod': Icons.payments_outlined,
  };

  Future<void> _pay() async {
    final l10n = AppLocalizations.of(context);

    final result = await ref
        .read(paymentControllerProvider)
        .pay(widget.total, _method);

    if (!mounted) return;

    if (result.success) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          icon: const Icon(
            Icons.check_circle,
            size: 56,
            color: AppColors.greenPrimary,
          ),
          title: Text(l10n.paymentSuccessTitle),
          content: Text(
            l10n.paymentSuccessBody(
              taka(widget.total),
              _method.title,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.viewOrderButton),
            ),
          ],
        ),
      );

      if (!mounted) return;

      ref.read(cartControllerProvider).clear();

      context.go(
        Uri(
          path: '/order-success',
          queryParameters: {
            'orderId': result.orderId,
            'eta': widget.eta,
          },
        ).toString(),
      );
    } else {
      final changeMethod = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(
            Icons.cancel,
            size: 56,
            color: AppColors.danger,
          ),
          title: Text(l10n.paymentFailedTitle),
          content: Text(l10n.paymentFailedBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.changePaymentMethodButton),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.tryAgainButton),
            ),
          ],
        ),
      );

      if (changeMethod == true && mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final processing = ref.watch(paymentControllerProvider).processing;

    return AppScreen(
      title: l10n.paymentTitle,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          AppCard(
            child: Row(
              children: [
                const Icon(
                  Icons.verified_user,
                  size: 40,
                  color: AppColors.greenPrimary,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.secureCheckoutTitle,
                        style: AppTextStyles.inter(
                          15,
                          w: FontWeight.w700,
                          c: AppColors.greenPrimary,
                        ),
                      ),
                      Text(
                        l10n.secureCheckoutBody,
                        style: AppTextStyles.inter(
                          12,
                          c: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SectionTitle(l10n.selectPaymentMethodTitle),
          for (final m in PaymentMethod.all)
            AppCard(
              margin: const EdgeInsets.only(bottom: 10),
              color: _method == m
                  ? AppColors.surfaceGreen
                  : Colors.white,
              onTap: () => setState(() => _method = m),
              child: Row(
                children: [
                  Icon(
                    _icons[m.id],
                    size: 28,
                    color: _method == m
                        ? AppColors.greenPrimary
                        : Colors.black54,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      m.title,
                      style: AppTextStyles.inter(
                        15,
                        w: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (_method == m)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.greenPrimary,
                    ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          AppCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.orderTotalLabel,
                  style: AppTextStyles.inter(
                    15,
                    w: FontWeight.w600,
                  ),
                ),
                Text(
                  taka(widget.total),
                  style: AppTextStyles.inter(
                    20,
                    w: FontWeight.w800,
                    c: AppColors.greenPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: processing
                  ? l10n.processingLabel
                  : l10n.payButtonLabel(taka(widget.total)),
              trailingIcon: processing ? null : Icons.lock,
              onPressed: processing ? null : _pay,
            ),
          ),
        ],
      ),
    );
  }
}