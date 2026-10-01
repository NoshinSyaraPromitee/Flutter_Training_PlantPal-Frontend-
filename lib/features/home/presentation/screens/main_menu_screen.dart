
import 'package:flutter/material.dart';
import 'package:plantpal/features/home/presentation/widgets/main_menu_mascot.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../widgets/main_menu_widgets.dart';
import '../../../../l10n/app_localizations.dart';

/// Main menu shown after login (route: /home).
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  static const int _points = 999;
  static const int _pointsPerTaka = 100;
  static const String _mascotName = 'Tetoro';

  // Swap these for your own tile art (same filenames in assets/images/ works too).
  static const _imgMyPlants = 'assets/images/myplant.png';
  static const _imgAiDoctor = 'assets/images/aidoctor.png';
  static const _imgFertilizer = 'assets/images/fertilizer.png';
  static const _imgMaintenance = 'assets/images/maintenance.png';
  static const _imgShop = 'assets/images/shop_image.png';

  void _back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final taka = (_points / _pointsPerTaka).round();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              children: [
                // Points + notifications
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PointsPill(
                      points: _points,
                      taka: taka,
                      label: l10n.pointsBalanceLabel(
                        _points.toString(),
                        taka.toString(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Color(0xFF8E1B1B),
                      ),
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(l10n.noNotificationsMessage),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                MainMenuMascot(
                  mascotName: _mascotName,
                  onBubbleTap: () => context.push('/plants'),
                ),
                const SizedBox(height: 16),

                // Upload button
                Material(
                  color: const Color(0xFF718355),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: Color(0xFF7BC65A),
                      width: 1.5,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => context.go('/scan'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.uploadPlantPhotoPrompt,
                            style: AppTextStyles.inter(
                              16,
                              c: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_circle_right_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // Menu tiles
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainMenuTile(
                      imageAsset: _imgMyPlants,
                      label: l10n.myPlantsMenuLabel,
                      onTap: () => context.push('/plants'),
                    ),
                    MainMenuTile(
                      imageAsset: _imgAiDoctor,
                      label: l10n.aiDoctorMenuLabel,
                      onTap: () => context.go('/ai-doctor'),
                    ),
                  ],
                ),
                const SizedBox(height: 44),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainMenuTile(
                      imageAsset: _imgFertilizer,
                      label: l10n.fertilizerRecipesMenuLabel,
                      onTap: () => context.push('/fertilizer'),
                    ),
                    MainMenuTile(
                      imageAsset: _imgMaintenance,
                      label: l10n.maintenanceMenuLabel,
                      onTap: () => context.push('/care-calendar'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                MainMenuTile(
                  imageAsset: _imgShop,
                  label: l10n.shopMenuLabel,
                  onTap: () => context.go('/shop'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: MainMenuBottomBar(
        cameraLabel: l10n.cameraLabel,
        chatLabel: l10n.chatWithExpertLabel,
        backLabel: l10n.backButton,
        onCamera: () => context.go('/scan'),
        onChat: () => context.go('/ai-doctor'),
        onBack: () => _back(context),
      ),
    );
  }
}