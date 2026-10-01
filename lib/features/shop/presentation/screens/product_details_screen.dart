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
import '../../../../core/widgets/net_image.dart';
import '../../../../core/widgets/quantity_stepper.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../reviews/presentation/widgets/reviews_section.dart';
import '../widgets/price_refresh_button.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState
    extends ConsumerState<ProductDetailsScreen> {
  int _qty = 1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(reviewsControllerProvider).load(widget.productId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final product =
        ref.watch(shopControllerProvider).byId(widget.productId);

    if (product == null) {
      return AppScreen(
        title: l10n.productFallbackTitle,
        child: ErrorView(
          message: l10n.productNotFoundMessage,
        ),
      );
    }

    final reviews = ref.watch(reviewsControllerProvider);
    final wishlist = ref.watch(wishlistControllerProvider);
    final liked = wishlist.contains(product.id);
    final count = reviews.of(product.id).length;
    final avg =
        reviews.average(product.id)?.toStringAsFixed(1) ??
            '${product.rating}';

    return AppScreen(
      title: l10n.detailsSectionTitle,
      trailing: IconButton(
        icon: Icon(
          liked
              ? Icons.favorite
              : Icons.favorite_border,
          color: liked
              ? AppColors.danger
              : AppColors.greenPrimary,
        ),
        onPressed: () => wishlist.toggle(product),
      ),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          NetImage(
            product.imageUrl,
            width: double.infinity,
            height: 260,
            radius: 24,
          ),
          const SizedBox(height: 14),
          Text(
            product.category,
            style: AppTextStyles.inter(
              13,
              c: AppColors.textMuted,
            ),
          ),
          Text(
            product.name,
            style: AppTextStyles.screenTitle.copyWith(
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.star,
                color: AppColors.star,
                size: 22,
              ),
              const SizedBox(width: 4),
              Text(
                avg,
                style: AppTextStyles.inter(
                  15,
                  w: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '(${l10n.productReviewsCount(count)}) • '
                '${l10n.productInStock(product.stock)}',
                style: AppTextStyles.inter(
                  13,
                  c: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                taka(product.price),
                style: AppTextStyles.inter(
                  26,
                  w: FontWeight.w800,
                  c: const Color(0xFFFF9800),
                ),
              ),
              if (product.unit != null) ...[
                const SizedBox(width: 10),
                Chip(
                  avatar: const Icon(
                    Icons.scale,
                    size: 14,
                    color: AppColors.greenPrimary,
                  ),
                  label: Text(product.unit!),
                  backgroundColor: AppColors.surfaceGreen,
                ),
              ],
            ],
          ),
          SectionTitle(
            l10n.descriptionSectionTitle,
          ),
          Text(
            product.description,
            style: AppTextStyles.inter(
              14,
              h: 1.5,
            ),
          ),
          SectionTitle(
            l10n.quantitySectionTitle,
          ),
          Row(
            children: [
              QuantityStepper(
                value: _qty,
                onMinus: () => setState(
                  () => _qty = _qty > 1 ? _qty - 1 : 1,
                ),
                onPlus: () => setState(
                  () => _qty++,
                ),
              ),
              if (product.unit != null) ...[
                const SizedBox(width: 12),
                Text(
                  l10n.productQuantityFormula(
                    _qty,
                    product.unit!,
                  ),
                  style: AppTextStyles.inter(
                    13,
                    c: AppColors.textMuted,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: l10n.addToCartButton,
              trailingIcon: Icons.add_shopping_cart,
              onPressed: () {
                ref
                    .read(cartControllerProvider)
                    .add(
                      product,
                      quantity: _qty,
                    );
                context.push('/cart');
              },
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: l10n.buyNowButton,
              variant: AppButtonVariant.orange,
              onPressed: () {
                ref
                    .read(cartControllerProvider)
                    .add(
                      product,
                      quantity: _qty,
                    );
                context.push('/checkout');
              },
            ),
          ),
          const SizedBox(height: 16),
          // AI-powered live price check.
          PriceRefreshButton(
            product: product,
            repository: ref.read(
              priceRefreshRepositoryProvider,
            ),
          ),
          const SizedBox(height: 4),
          ReviewsSection(
            productId: product.id,
          ),
        ],
      ),
    );
  }
}