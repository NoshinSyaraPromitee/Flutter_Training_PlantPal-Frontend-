import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:plantpal/core/widgets/gradient_background.dart';
import 'package:plantpal/core/widgets/fb_community_popup.dart';
import 'package:plantpal/features/gamification/presentation/providers/points_provider.dart';
import 'package:plantpal/features/home/presentation/widgets/main_menu_mascot.dart';
import 'package:plantpal/features/home/presentation/widgets/main_menu_upload_button.dart';
import 'package:plantpal/features/home/presentation/widgets/main_menu_points.dart';
import 'package:plantpal/features/home/presentation/widgets/main_menu_widgets.dart';
import 'package:plantpal/l10n/app_localizations.dart';

/// Main menu shown after login (route: /home).
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  static const int _pointsPerTaka = 100;

  // Swap these for your own tile art (same filenames in assets/images/ works too).
  static const _imgMyPlants = 'assets/images/corner_flowers.png';
  static const _imgAiDoctor = 'assets/images/disease_plant.png';
  static const _imgFertilizer = 'assets/images/fertilizer_bag.png';
  static const _imgMaintenance = 'assets/images/maintenance_cactus.png';
  static const _imgShop = 'assets/images/shop_image.png';
  static const _imgMascot = 'assets/images/splash_mascot.png';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) FbCommunityPopup.maybeShow(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final points = context.watch<PointsController>().balance;
    final taka = (points / _pointsPerTaka).round();
    final t = AppLocalizations.of(context);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PointsPill(points: points, taka: taka),
                    IconButton(
                      icon: const Icon(Icons.notifications_none, color: Color(0xFF8E1B1B)),
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(t.noNewNotifications)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                MainMenuMascot(
                  imageAsset: _imgMascot,
                  onBubbleTap: () => context.push('/plants'),
                ),
                const SizedBox(height: 16),
                MainMenuUploadButton(
                  label: t.uploadPlantPhoto,
                  onTap: () => context.go('/scan'),
                ),
                const SizedBox(height: 36),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainMenuTile(
                      imageAsset: _imgMyPlants,
                      label: t.myPlants,
                      onTap: () => context.push('/plants'),
                    ),
                    MainMenuTile(
                      imageAsset: _imgAiDoctor,
                      label: t.aiDoctor,
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
                      label: t.fertilizerRecipes,
                      onTap: () => context.push('/fertilizer'),
                    ),
                    MainMenuTile(
                      imageAsset: _imgMaintenance,
                      label: t.maintenance,
                      onTap: () => context.push('/care-calendar'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                MainMenuTile(imageAsset: _imgShop, label: t.shop, onTap: () => context.go('/shop')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}