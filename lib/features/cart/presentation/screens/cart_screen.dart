import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../core/widgets/net_image.dart';
import '../../../../core/widgets/price_summary.dart';
import '../../../../core/widgets/quantity_stepper.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../app/riverpod_providers.dart';
import '../../../checkout/domain/model/checkout_models.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cart = ref.watch(cartControllerProvider);

    if (cart.isEmpty) {
      return AppScreen(
        title: l10n.cartTitle,
        child: EmptyView(
          icon: Icons.shopping_cart_outlined,
          title: l10n.cartEmptyTitle,
          actionLabel: l10n.continueShoppingButton,
          onAction: () => context.go('/shop'),
        ),
      );
    }

    final s = const CalculateOrderSummary()(
      cart.subtotal,
      DeliveryOption.standard,
    );

    return AppScreen(
      title: l10n.cartTitle,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              itemCount: cart.items.length,
              itemBuilder: (_, i) {
                final item = cart.items[i];
                final p = item.product;

                return AppCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      NetImage(
                        p.imageUrl,
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.inter(
                                15,
                                w: FontWeight.w700,
                              ),
                            ),
                            Text(
                              p.unit == null
                                  ? p.category
                                  : '${p.category} • ${p.unit}',
                              style: AppTextStyles.inter(
                                12,
                                c: AppColors.textMuted,
                              ),
                            ),
                            Text(
                              taka(p.price),
                              style: AppTextStyles.inter(
                                15,
                                w: FontWeight.w800,
                                c: const Color(0xFFFF9800),
                              ),
                            ),
                            const SizedBox(height: 6),
                            QuantityStepper(
                              value: item.quantity,
                              onMinus: () => cart.decrease(p.id),
                              onPlus: () => cart.increase(p.id),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.danger,
                          size: 26,
                        ),
                        onPressed: () => cart.remove(p.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          PriceSummary(
            subtotal: s.subtotal,
            shipping: s.shipping,
            tax: s.tax,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: l10n.proceedToCheckoutButton,
              onPressed: () => context.push('/checkout'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

