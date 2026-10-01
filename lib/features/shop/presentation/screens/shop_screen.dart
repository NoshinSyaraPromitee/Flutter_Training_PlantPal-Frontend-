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

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  @override
  void initState() {
    super.initState();
    // If nothing has been loaded yet (e.g. the post-login load never ran or
    // failed), fetch now instead of spinning forever / showing "no products".
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final shop = ref.read(shopControllerProvider);
      if (shop.products.isEmpty && !shop.isFetching) shop.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final shop = ref.watch(shopControllerProvider);
    final cart = ref.watch(cartControllerProvider);
    final filteredProducts = shop.filtered;

    Widget body;
    if (shop.loading) {
      body = const LoadingView();
    } else if (shop.error != null && shop.products.isEmpty) {
      body = ErrorView(message: shop.error!, onRetry: shop.load);
    } else if (filteredProducts.isEmpty) {
      body = EmptyView(
        icon: Icons.storefront,
        title: l10n.noProductsFoundTitle,
      );
    } else {
      body = GridView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: 262, // fixed height: no overflow on narrow phones
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (_, i) => _ProductCard(product: filteredProducts[i]),
      );
    }

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
                _CategoryChip(
                  label: l10n.allCategoryLabel,
                  selected: shop.category == 'All',
                  onTap: () => shop.selectCategory('All'),
                ),
                for (final cat in shop.categories)
                  _CategoryChip(
                    label: cat.name,
                    selected: shop.category == cat.name,
                    onTap: () => shop.selectCategory(cat.name),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        selectedColor: AppColors.greenPrimary,
        backgroundColor: AppColors.cream,
        side: BorderSide(
          color: AppColors.cream.withValues(alpha: 0.8),
          width: 1.5,
        ),
        labelStyle: AppTextStyles.inter(
          13,
          c: selected ? Colors.white : const Color(0xFF1A3A31),
          w: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProductCard extends ConsumerWidget {
  const _ProductCard({required this.product});

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
      onTap: () => context.push('/shop/product/${product.id}'),
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
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.inter(13, w: FontWeight.w700),
                ),
                if (product.unit != null)
                  Text(
                    product.unit!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.inter(11, c: AppColors.textMuted),
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
                            backgroundColor: AppColors.greenPrimary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onPressed: () => cart.add(product),
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
                        onMinus: () => cart.decrease(product.id),
                        onPlus: () => cart.increase(product.id),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}