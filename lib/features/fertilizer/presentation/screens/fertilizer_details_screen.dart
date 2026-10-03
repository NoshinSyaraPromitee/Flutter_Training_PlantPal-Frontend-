import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:plantpal/core/theme/app_colors.dart";
import "package:plantpal/core/theme/app_text_styles.dart";
import "package:plantpal/core/widgets/app_card.dart";
import "package:plantpal/core/widgets/app_screen.dart";
import "package:plantpal/core/widgets/net_image.dart";
import "package:plantpal/core/widgets/state_views.dart";
import "package:plantpal/features/fertilizer/presentation/providers/fertilizer_providers.dart";

class FertilizerDetailsScreen extends ConsumerWidget {
  const FertilizerDetailsScreen({super.key, required this.id});
  final String id;

  Widget _row(IconData icon, Color color, String text, {Color? textColor}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTextStyles.inter(14, c: textColor, h: 1.4))),
        ]),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = ref.watch(fertilizerByIdProvider(id));
    if (f == null) return const AppScreen(title: "Recipe", child: ErrorView(message: "Recipe not found."));

    final safetyTips = ref.watch(fertilizerRecipesProvider).value?.safetyTips ?? const <String>[];

    return AppScreen(
      title: "Recipe",
      child: ListView(padding: const EdgeInsets.only(bottom: 32), children: [
        NetImage(f.imageUrl, width: double.infinity, height: 200, radius: 20),
        const SizedBox(height: 14),
        Text(f.name, style: AppTextStyles.screenTitle.copyWith(fontSize: 28)),
        const SizedBox(height: 6),
        Row(children: [
          const Icon(Icons.track_changes, size: 16, color: AppColors.greenPrimary),
          const SizedBox(width: 6),
          Text(f.purpose, style: AppTextStyles.inter(14, w: FontWeight.w600, c: AppColors.greenPrimary)),
        ]),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: AppColors.surfaceGreen, borderRadius: BorderRadius.circular(12)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.bubble_chart, size: 14, color: Color(0xFF558B2F)),
            const SizedBox(width: 4),
            Text(f.nutrient, style: AppTextStyles.inter(12, w: FontWeight.w600, c: const Color(0xFF558B2F))),
          ]),
        ),
        const SectionTitle("Ingredients"),
        AppCard(child: Column(children: [for (final i in f.ingredients) _row(Icons.circle, const Color(0xFF43A047), i)])),
        const SectionTitle("Preparation"),
        AppCard(
          child: Column(children: [
            for (var i = 0; i < f.preparation.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  CircleAvatar(radius: 11, backgroundColor: AppColors.greenPrimary, child: Text("${i + 1}", style: AppTextStyles.inter(11, w: FontWeight.w700, c: Colors.white))),
                  const SizedBox(width: 10),
                  Expanded(child: Text(f.preparation[i], style: AppTextStyles.inter(14, h: 1.4))),
                ]),
              ),
          ]),
        ),
        const SectionTitle("Application"),
        AppCard(child: _row(Icons.water_drop_outlined, AppColors.waterBlue, f.application)),
        const SectionTitle("Benefits"),
        AppCard(child: Column(children: [for (final b in f.benefits) _row(Icons.check_circle, const Color(0xFF43A047), b)])),
        const SectionTitle("Safety Tips"),
        AppCard(
          color: const Color(0xFFFFF3E0),
          child: Column(children: [for (final t in safetyTips) _row(Icons.warning_amber_rounded, const Color(0xFFFB8C00), t, textColor: const Color(0xFF1A3A31))]),
        ),
      ]),
    );
  }
}

