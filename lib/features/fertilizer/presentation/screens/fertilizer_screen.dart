import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/net_image.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/fertilizer.dart';

/// Fertilizer info / recipe screen.
class FertilizerScreen extends ConsumerWidget {
  const FertilizerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = ref.watch(fertilizerControllerProvider);
    final list = c.filtered;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.fertilizerMakingTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.screenTitle,
                ),
                const SizedBox(height: 12),
                Center(
                  child: Image.asset(
                    'assets/images/fertilizer.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 20),
                _FertilizerSearchBar(
                  hint: l10n.fertilizerSearchSubtitle,
                  onChanged: c.setQuery,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: c.loading
                      ? const LoadingView()
                      : list.isEmpty
                          ? EmptyView(
                              icon: Icons.science_outlined,
                              title: l10n.noRecipesFoundTitle,
                              subtitle: l10n.noRecipesFoundBody(c.query),
                            )
                          : ListView.separated(
                              itemCount: list.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (_, i) => _RecipeCard(
                                item: list[i],
                                nutrientLabel: l10n.nutrientLabel,
                              ),
                            ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppButton(
                      label: l10n.backButton,
                      variant: AppButtonVariant.green,
                      onPressed: () => context.canPop()
                          ? context.pop()
                          : context.go('/home'),
                    ),
                    AppButton(
                      label: l10n.addFertilizerButton,
                      variant: AppButtonVariant.orange,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FertilizerSearchBar extends StatelessWidget {
  const _FertilizerSearchBar({
    required this.hint,
    required this.onChanged,
  });

  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greenCardFill.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(28),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.menu),
          suffixIcon: const Icon(Icons.search),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({
    required this.item,
    required this.nutrientLabel,
  });

  final Fertilizer item;
  final String Function(String) nutrientLabel;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.greenCardFill,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/fertilizer/${item.id}'),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              NetImage(
                item.imageUrl,
                width: 64,
                height: 64,
                radius: 10,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTextStyles.inter(
                        14,
                        w: FontWeight.w700,
                      ),
                    ),
                    Text(
                      item.purpose,
                      style: AppTextStyles.bodyText,
                    ),
                    Text(
                      nutrientLabel(item.nutrient),
                      style: AppTextStyles.inter(
                        11,
                        c: AppColors.greenPrimary,
                        w: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}