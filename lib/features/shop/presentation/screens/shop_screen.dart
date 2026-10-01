import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../core/widgets/net_image.dart';
import '../../../../core/widgets/quantity_stepper.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/product.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final shop = ref.watch(shopControllerProvider);
    final cart = ref.watch(cartControllerProvider);
    final filteredProducts = shop.filtered;

    return AppScreen(
      title: l10n.shopTitle,
      trailing: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.greenPrimary,
            ),
            onPressed: () => context.push('/cart'),
            tooltip: l10n.cartTitle,
          ),
          if (cart.count > 0)
            Positioned(
              top: 6,
              right: 6,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: AppColors.danger,
                child: Text(
                  '${cart.count}',
                  style: AppTextStyles.inter(
                    9,
                    w: FontWeight.w800,
                    c: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(l10n.allCategoryLabel),
                    selected: shop.category == 'All',
                    onSelected: (_) =>
                        shop.selectCategory('All'),
                    selectedColor: AppColors.greenPrimary,
                    labelStyle: AppTextStyles.inter(
                      13,
                      c: shop.category == 'All'
                          ? Colors.white
                          : AppColors.textDark,
                      w: FontWeight.w600,
                    ),
                  ),
                ),
                for (final cat in shop.categories)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat.name),
                      selected: shop.category == cat.name,
                      onSelected: (_) =>
                          shop.selectCategory(cat.name),
                      selectedColor: AppColors.greenPrimary,
                      labelStyle: AppTextStyles.inter(
                        13,
                        c: shop.category == cat.name
                            ? Colors.white
                            : AppColors.textDark,
                        w: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: shop.loading
                ? const LoadingView()
                : filteredProducts.isEmpty
                    ? EmptyView(
                        icon: Icons.storefront,
                        title: l10n.noProductsFoundTitle,
                      )
                    : GridView.builder(
                        padding:
                            const EdgeInsets.only(bottom: 24),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (_, i) => _ProductCard(
                          product: filteredProducts[i],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends ConsumerWidget {
  const _ProductCard({
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cart = ref.watch(cartControllerProvider);

    final cartItem = cart.items
        .where((item) => item.product.id == product.id)
        .firstOrNull;

    final qty = cartItem?.quantity ?? 0;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: NetImage(
                product.imageUrl,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              10,
              8,
              10,
              10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.inter(
                    13,
                    w: FontWeight.w700,
                  ),
                ),
                if (product.unit != null)
                  Text(
                    product.unit!,
                    style: AppTextStyles.inter(
                      11,
                      c: AppColors.textMuted,
                    ),
                  ),
                Text(
                  taka(product.price),
                  style: AppTextStyles.inter(
                    14,
                    w: FontWeight.w800,
                    c: const Color(0xFFFF9800),
                  ),
                ),
                const SizedBox(height: 6),
                qty == 0
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.greenPrimary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                            padding:
                                const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                          ),
                          onPressed: () =>
                              cart.add(product),
                          child: Text(
                            l10n.addToCartButton,
                            style: AppTextStyles.inter(
                              12,
                              w: FontWeight.w700,
                              c: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : QuantityStepper(
                        value: qty,
                        onMinus: () =>
                            cart.decrease(product.id),
                        onPlus: () =>
                            cart.increase(product.id),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}