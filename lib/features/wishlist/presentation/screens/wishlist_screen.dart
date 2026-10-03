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
import '../../../../core/widgets/state_views.dart';
import '../../../../l10n/app_localizations.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final wishlist = ref.watch(wishlistControllerProvider);

    return AppScreen(
      title: l10n.wishlistTitle,
      child: wishlist.items.isEmpty
          ? EmptyView(
              icon: Icons.favorite_border,
              title: l10n.wishlistEmptyTitle,
              subtitle: l10n.wishlistEmptyBody,
              actionLabel: l10n.browseShopButton,
              onAction: () => context.go('/shop'),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 24,
              ),
              itemCount: wishlist.items.length,
              itemBuilder: (_, i) {
                final p = wishlist.items[i];

                return AppCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  onTap: () =>
                      context.push('/shop/product/${p.id}'),
                  child: Row(
                    children: [
                      NetImage(
                        p.imageUrl,
                        width: 84,
                        height: 84,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.inter(
                                15,
                                w: FontWeight.w700,
                                c: AppColors.greenPrimary,
                              ),
                            ),
                            Text(
                              p.category,
                              style: AppTextStyles.inter(
                                12,
                                c: AppColors.textMuted,
                              ),
                            ),
                            Text(
                              taka(p.price),
                              style: AppTextStyles.inter(
                                16,
                                w: FontWeight.w800,
                                c: const Color(0xFFFF9800),
                              ),
                            ),
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () => ref
                                      .read(
                                        cartControllerProvider,
                                      )
                                      .add(p),
                                  icon: const Icon(
                                    Icons.add_shopping_cart,
                                    size: 16,
                                  ),
                                  label: Text(
                                    l10n.addToCartButton,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: AppColors.danger,
                                  ),
                                  onPressed: () =>
                                      wishlist.remove(p.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}