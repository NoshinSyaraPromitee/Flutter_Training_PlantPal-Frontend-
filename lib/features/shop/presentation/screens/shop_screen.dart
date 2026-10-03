import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/app_screen.dart';
import 'package:plantpal/core/widgets/app_text_field.dart';
import 'package:plantpal/core/widgets/state_views.dart';
import 'package:plantpal/features/cart/presentation/providers/cart_provider.dart';
import 'package:plantpal/features/shop/presentation/providers/shop_provider.dart';
import 'package:plantpal/features/shop/presentation/widgets/product_card.dart';
import 'package:plantpal/features/wishlist/presentation/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  Widget _iconBadge(IconData icon, int count, VoidCallback onTap) => IconButton(
        onPressed: onTap,
        icon: Badge(isLabelVisible: count > 0, label: Text('$count'), child: Icon(icon, size: 28, color: AppColors.isDark ? Colors.white : AppColors.greenPrimary)),
      );

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopController>();
    final cartCount = context.watch<CartController>().count;
    final wishCount = context.watch<WishlistController>().items.length;
    final list = shop.filtered;

    return AppScreen(
      title: 'Shop',
      showBack: false,
      child: shop.loading
          ? const LoadingView()
          : shop.error != null
              ? ErrorView(message: shop.error!, onRetry: shop.load)
              : Column(children: [
                  Row(children: [

                    _iconBadge(Icons.favorite_border, wishCount, () => context.push('/wishlist')),
                    _iconBadge(Icons.shopping_cart_outlined, cartCount, () => context.push('/cart')),
                  ]),
                  AppTextField(hint: 'Search products...', icon: Icons.search, radius: 18, onChanged: shop.setQuery),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 42,
                    child: ListView(scrollDirection: Axis.horizontal, children: [
                      for (final name in ['All', ...shop.categories.map((c) => c.name)])
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(name),
                            selected: shop.category == name,
                            onSelected: (_) => shop.selectCategory(name),
                            selectedColor: AppColors.greenPrimary,
                            backgroundColor: AppColors.isDark ? AppColors.surfaceGreen : Colors.white,
                            labelStyle: AppTextStyles.inter(13, w: FontWeight.w600, c: shop.category == name ? Colors.white : AppColors.textDark),
                            showCheckmark: false,
                          ),
                        ),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: list.isEmpty
                        ? const EmptyView(icon: Icons.search, title: 'No products found')
                        : GridView.builder(
                            padding: const EdgeInsets.only(bottom: 24),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 0.66,
                            ),
                            itemCount: list.length,
                            itemBuilder: (_, i) => ProductCard(product: list[i]),
                          ),
                  ),
                ]),
    );
  }
}