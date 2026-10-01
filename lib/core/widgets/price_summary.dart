import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import 'app_card.dart';

/// Subtotal/shipping/tax/total breakdown used on cart and checkout.
class PriceSummary extends StatelessWidget {
  const PriceSummary({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.tax,
  });

  final double subtotal;
  final double shipping;
  final double tax;

  @override
  Widget build(BuildContext context) {
    Widget row(String label, double value, {bool bold = false}) {
      final style = AppTextStyles.inter(
        bold ? 17 : 14,
        w: bold ? FontWeight.w700 : FontWeight.w500,
      );
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: style),
            Text(taka(value), style: style),
          ],
        ),
      );
    }

    return AppCard(
      child: Column(
        children: [
          row('Subtotal', subtotal),
          row('Shipping', shipping),
          row('Tax (5%)', tax),
          const Divider(),
          row('Total', subtotal + shipping + tax, bold: true),
        ],
      ),
    );
  }
}