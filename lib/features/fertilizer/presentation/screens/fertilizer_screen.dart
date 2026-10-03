import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:plantpal/core/widgets/app_back_button.dart";
import "package:plantpal/core/theme/app_text_styles.dart";
import "package:plantpal/core/widgets/app_button.dart";
import "package:plantpal/core/widgets/gradient_background.dart";
import "package:plantpal/core/widgets/shimmer_placeholder.dart";
import "package:plantpal/core/widgets/state_views.dart";
import "package:plantpal/features/fertilizer/presentation/providers/fertilizer_providers.dart";
import "package:plantpal/features/fertilizer/presentation/widgets/fertilizer_list_widgets.dart";

/// Fertilizer info / recipe screen.
class FertilizerScreen extends ConsumerWidget {
  const FertilizerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogAsync = ref.watch(fertilizerRecipesProvider);
    final query = ref.watch(fertilizerQueryProvider);
    final list = ref.watch(filteredFertilizersProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [
                  const SizedBox(width: 48, child: AppBackButton()),
                  Expanded(child: Text("Fertilizer Making", textAlign: TextAlign.center, style: AppTextStyles.screenTitle.copyWith(fontSize: 30))),
                  const SizedBox(width: 48),
                ]),
                const SizedBox(height: 12),
                Center(child: Image.asset("assets/images/fertilizer_bag.png", width: 100, height: 100)),
                const SizedBox(height: 20),
                FertilizerSearchBar(
                  onChanged: (q) => ref.read(fertilizerQueryProvider.notifier).set(q),
                  hint: "Find your homemade fertilizer",
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: "Add Fertilizer Recipe",
                  variant: AppButtonVariant.orange,
                  leadingIcon: Icons.add,
                  onPressed: () => context.push("/fertilizer/add"),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: catalogAsync.isLoading
                      ? const ShimmerListPlaceholder()
                      : catalogAsync.hasError
                          ? const ErrorView(message: "Could not load fertilizer recipes.")
                          : list.isEmpty
                              ? EmptyView(icon: Icons.science_outlined, title: "No recipes found", subtitle: "Nothing matches \u201c$query\u201d.")
                              : ListView.separated(
                                  itemCount: list.length,
                                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                                  itemBuilder: (_, i) => FertilizerRecipeCard(item: list[i]),
                                ),
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

