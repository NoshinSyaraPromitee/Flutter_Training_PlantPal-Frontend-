import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:plantpal/core/widgets/fb_community_popup.dart';
import 'package:plantpal/core/widgets/gradient_background.dart';
import 'package:plantpal/features/gamification/presentation/providers/points_provider.dart';
import 'package:plantpal/features/home/presentation/widgets/menu_colors.dart';
import 'package:plantpal/features/home/presentation/widgets/menu_hero_card.dart';
import 'package:plantpal/features/home/presentation/widgets/menu_tile.dart';
import 'package:plantpal/features/home/presentation/widgets/menu_top_bar.dart';
import 'package:plantpal/l10n/app_localizations.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) FbCommunityPopup.maybeShow(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final points = context.watch<PointsController>().balance;
    final taka = (points / PointsController.pointsPerTaka).round();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ---- Top bar: points + notifications ----
                    Row(
                      children: [
                        MenuPointsChip(
                          label: l10n.pointsBalanceLabel(
                            points.toString(),
                            taka.toString(),
                          ),
                        ),
                        const Spacer(),
                        MenuBellButton(
                          onTap: () => ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(l10n.noNotificationsMessage),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ---- Hero: mascot + greeting + upload ----
                    MenuHeroCard(
                      uploadLabel: l10n.uploadPlantPhotoPrompt,
                      onBubbleTap: () => context.push('/plants'),
                      onUpload: () => context.go('/scan'),
                    ),
                    const SizedBox(height: 16),

                    // ---- Bento grid ----
                    SizedBox(
                      height: 214,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 11,
                            child: MenuTile(
                              layout: MenuTileLayout.tall,
                              label: l10n.myPlantsMenuLabel,
                              image: 'assets/images/myplant.png',
                              fill: MenuColors.cream,
                              onTap: () => context.push('/plants'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 10,
                            child: Column(
                              children: [
                                Expanded(
                                  child: MenuTile(
                                    layout: MenuTileLayout.compact,
                                    label: l10n.aiDoctorMenuLabel,
                                    image: 'assets/images/aidoctor.png',
                                    fill: MenuColors.sage,
                                    onTap: () => context.go('/ai-doctor'),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: MenuTile(
                                    layout: MenuTileLayout.compact,
                                    label: l10n.maintenanceMenuLabel,
                                    image: 'assets/images/maintenance.png',
                                    fill: MenuColors.gold,
                                    onTap: () => context.push('/care-calendar'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 92,
                      child: MenuTile(
                        layout: MenuTileLayout.wide,
                        label: l10n.fertilizerRecipesMenuLabel,
                        image: 'assets/images/fertilizer.png',
                        fill: MenuColors.cream,
                        onTap: () => context.push('/fertilizer'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 92,
                      child: MenuTile(
                        layout: MenuTileLayout.wide,
                        label: l10n.shopMenuLabel,
                        image: 'assets/images/shop_image.png',
                        fill: MenuColors.teal,
                        dark: true,
                        onTap: () => context.go('/shop'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
