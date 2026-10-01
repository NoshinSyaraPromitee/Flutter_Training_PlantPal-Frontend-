
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
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/price_summary.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/checkout_models.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  DeliveryOption _delivery = DeliveryOption.standard;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  void _continue(OrderSummary s) {
    final err = ShippingInfo(
      name: _name.text,
      phone: _phone.text,
      address: _address.text,
    ).validate();

    if (err != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(err)));
      return;
    }

    context.push(
      Uri(
        path: '/payment',
        queryParameters: {
          'total': s.total.toStringAsFixed(2),
          'eta': _delivery.eta,
        },
      ).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cart = ref.watch(cartControllerProvider);

    if (cart.isEmpty) {
      return AppScreen(
        title: l10n.checkoutTitle,
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
      _delivery,
    );

    return AppScreen(
      title: l10n.checkoutTitle,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          SectionTitle(l10n.shippingInfoTitle),
          AppTextField(
            controller: _name,
            hint: l10n.fullNameLabel,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _phone,
            hint: l10n.phoneNumberLabel,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _address,
            hint: l10n.shippingAddressLabel,
            icon: Icons.location_on_outlined,
            maxLines: 3,
          ),
          SectionTitle(l10n.deliveryMethodLabel),
          for (final d in DeliveryOption.all)
            AppCard(
              margin: const EdgeInsets.only(bottom: 10),
              color: _delivery == d
                  ? AppColors.surfaceGreen
                  : Colors.white,
              onTap: () => setState(() => _delivery = d),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.title,
                          style: AppTextStyles.inter(
                            15,
                            w: FontWeight.w700,
                          ),
                        ),
                        Text(
                          l10n.checkoutDeliveryEtaFee(
                            d.eta,
                            taka(d.fee),
                          ),
                          style: AppTextStyles.inter(
                            13,
                            c: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_delivery == d)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.greenPrimary,
                    ),
                ],
              ),
            ),
          SectionTitle(l10n.orderSummaryTitle),
          PriceSummary(
            subtotal: s.subtotal,
            shipping: s.shipping,
            tax: s.tax,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: l10n.continueToPaymentButton,
              onPressed: () => _continue(s),
            ),
          ),
        ],
      ),
    );
  }
}