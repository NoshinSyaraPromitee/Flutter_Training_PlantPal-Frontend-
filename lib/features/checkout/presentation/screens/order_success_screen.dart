
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../l10n/app_localizations.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.eta,
  });

  final String orderId;
  final String eta;

  Widget _row(
    BuildContext context,
    String l,
    String v, {
    Color? color,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l,
              style: AppTextStyles.inter(
                14,
                c: AppColors.textMuted,
              ),
            ),
            Text(
              v,
              style: AppTextStyles.inter(
                14,
                w: FontWeight.w700,
                c: color ?? AppColors.textDark,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.greenPrimary,
                  child: Icon(
                    Icons.check,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.orderConfirmedTitle,
                  style: AppTextStyles.screenTitle,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.orderConfirmedBody,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyText,
                ),
                const SizedBox(height: 24),
                AppCard(
                  child: Column(
                    children: [
                      _row(
                        context,
                        l10n.orderIdLabel,
                        l10n.orderIdValue(orderId),
                      ),
                      const Divider(),
                      _row(
                        context,
                        l10n.estimatedDeliveryLabel,
                        eta,
                      ),
                      const Divider(),
                      _row(
                        context,
                        l10n.statusLabel,
                        l10n.statusProcessing,
                        color: AppColors.greenPrimary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: l10n.backToHomeButton,
                    trailingIcon: Icons.home,
                    onPressed: () => context.go('/home'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: l10n.continueShoppingButton,
                    variant: AppButtonVariant.orange,
                    trailingIcon: Icons.shopping_bag_outlined,
                    onPressed: () => context.go('/shop'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

