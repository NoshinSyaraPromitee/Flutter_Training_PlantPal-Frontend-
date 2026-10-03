import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/utils/formatters.dart';
import 'package:plantpal/core/widgets/app_card.dart';
import 'package:plantpal/core/widgets/net_image.dart';
import 'package:plantpal/features/cart/presentation/providers/cart_provider.dart';
import 'package:plantpal/features/shop/domain/model/product.dart';
import 'package:plantpal/features/wishlist/presentation/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistController>();
    final liked = wishlist.contains(product.id);

    return AppCard(
      padding: const EdgeInsets.all(10),
      radius: 22,
      onTap: () => context.push('/shop/product/${product.id}'),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Stack(children: [
            Positioned.fill(child: NetImage(product.imageUrl)),
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.star, size: 14, color: AppColors.star),
                  const SizedBox(width: 3),
                  Text('${product.rating}', style: AppTextStyles.inter(12, w: FontWeight.w600, c: const Color(0xFF1A3A31))),
                ]),
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: InkWell(
                onTap: () => wishlist.toggle(product),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(liked ? Icons.favorite : Icons.favorite_border, size: 18, color: liked ? AppColors.danger : AppColors.greenPrimary),
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 8),
        Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.inter(14, w: FontWeight.w700, c: AppColors.isDark ? AppColors.cream : AppColors.greenPrimary)),
        Row(children: [
          Flexible(child: Text(product.category, style: AppTextStyles.inter(12, c: AppColors.textMuted))),
          if (product.unit != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(color: AppColors.surfaceGreen, borderRadius: BorderRadius.circular(8)),
              child: Text(product.unit!, style: AppTextStyles.inter(10, w: FontWeight.w700, c: AppColors.isDark ? AppColors.cream : AppColors.greenPrimary)),
            ),
          ],
        ]),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(taka(product.price), style: AppTextStyles.inter(15, w: FontWeight.w800, c: const Color(0xFFFF9800))),
          InkWell(
            onTap: () {
              context.read<CartController>().add(product);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text('${product.name} added to cart'), duration: const Duration(seconds: 1)));
            },
            child: const CircleAvatar(radius: 18, backgroundColor: AppColors.greenPrimary, child: Icon(Icons.add_shopping_cart, size: 18, color: Colors.white)),
          ),
        ]),
      ]),
    );
  }
}