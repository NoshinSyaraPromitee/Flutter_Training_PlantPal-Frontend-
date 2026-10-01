import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ConsumerWidget, WidgetRef;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/fb_community_popup.dart';
import 'package:plantpal/core/widgets/gradient_background.dart';
import 'package:plantpal/core/widgets/plant_mascot_rive.dart';
import 'package:plantpal/features/gamification/presentation/providers/points_provider.dart';
import 'package:plantpal/features/home/domain/greeting.dart';
import 'package:plantpal/features/home/presentation/providers/greeting_providers.dart';
import 'package:plantpal/features/plants/presentation/providers/plants_provider.dart';
import 'package:plantpal/l10n/app_localizations.dart';

// Landing palette.
const _teal = Color(0xFF1B5A4B);
const _tealLight = Color(0xFF2C7A63);
const _cream = Color(0xFFFFF6DC);
const _ink = Color(0xFF123F35);
const _sage = Color(0xFFE3EDBE);
const _gold = Color(0xFFF6E7A1);

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
                        _PointsChip(
                          label: l10n.pointsBalanceLabel(
                            points.toString(),
                            taka.toString(),
                          ),
                        ),
                        const Spacer(),
                        _BellButton(
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
                    _HeroCard(
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
                            child: _Tile(
                              layout: _TileLayout.tall,
                              label: l10n.myPlantsMenuLabel,
                              image: 'assets/images/myplant.png',
                              fill: _cream,
                              onTap: () => context.push('/plants'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 10,
                            child: Column(
                              children: [
                                Expanded(
                                  child: _Tile(
                                    layout: _TileLayout.compact,
                                    label: l10n.aiDoctorMenuLabel,
                                    image: 'assets/images/aidoctor.png',
                                    fill: _sage,
                                    onTap: () => context.go('/ai-doctor'),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: _Tile(
                                    layout: _TileLayout.compact,
                                    label: l10n.maintenanceMenuLabel,
                                    image: 'assets/images/maintenance.png',
                                    fill: _gold,
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
                      child: _Tile(
                        layout: _TileLayout.wide,
                        label: l10n.fertilizerRecipesMenuLabel,
                        image: 'assets/images/fertilizer.png',
                        fill: _cream,
                        onTap: () => context.push('/fertilizer'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 92,
                      child: _Tile(
                        layout: _TileLayout.wide,
                        label: l10n.shopMenuLabel,
                        image: 'assets/images/shop_image.png',
                        fill: _teal,
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

// ---------------------------------------------------------------------------
// Top bar pieces
// ---------------------------------------------------------------------------

class _PointsChip extends StatelessWidget {
  const _PointsChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 5, 14, 5),
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _teal, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFE04A), Color(0xFFF5A300)],
              ),
            ),
            child: const Icon(
              Icons.star_rounded,
              size: 16,
              color: Color(0xFFFFF2A8),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.inter(12, w: FontWeight.w800, c: _ink),
          ),
        ],
      ),
    );
  }
}

class _BellButton extends StatelessWidget {
  const _BellButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _cream,
      elevation: 3,
      shape: const CircleBorder(side: BorderSide(color: _teal, width: 1.5)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(9),
          child: Icon(Icons.notifications_none_rounded, color: _teal, size: 24),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero card
// ---------------------------------------------------------------------------

class _HeroCard extends ConsumerWidget {
  const _HeroCard({
    required this.uploadLabel,
    required this.onBubbleTap,
    required this.onUpload,
  });

  final String uploadLabel;
  final VoidCallback onBubbleTap;
  final VoidCallback onUpload;

  static const String _mascotName = 'Tetoro';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final waterTodayCount = context.watch<PlantsController>().waterTodayCount;
    final greeting = waterTodayCount > 0
        ? const Greeting(GreetingKind.plantThirsty)
        : ref.watch(greetingMessageProvider);
    final bubbleText = _greetingText(t, greeting);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_teal, _tealLight],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _cream.withValues(alpha: 0.75), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mascot + name tag
          SizedBox(
            width: 108,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 108,
                  height: 124,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFD4C26E),
                        Color(0xFF7F9B5B),
                        Color(0xFF1B5A4B),
                      ],
                    ),
                    border: Border.all(color: _cream, width: 2.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(19),
                    child: const PlantMascotRive(),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                    color: _cream,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _mascotName,
                    style: AppTextStyles.inter(12, w: FontWeight.w800, c: _ink),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Greeting + upload button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  color: _cream.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: onBubbleTap,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        bubbleText,
                        style: AppTextStyles.inter(
                          14,
                          w: FontWeight.w700,
                          c: _cream,
                          h: 1.35,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Material(
                  color: _cream,
                  elevation: 3,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: onUpload,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              uploadLabel,
                              maxLines: 2,
                              style: AppTextStyles.inter(
                                14,
                                w: FontWeight.w800,
                                c: _teal,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_circle_right_outlined,
                            color: _teal,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _greetingText(AppLocalizations t, Greeting greeting) {
  switch (greeting.kind) {
    case GreetingKind.morning:
      return t.greetingMorning;
    case GreetingKind.afternoon:
      return t.greetingAfternoon;
    case GreetingKind.evening:
      return t.greetingEvening;
    case GreetingKind.night:
      return t.greetingNight;
    case GreetingKind.plantThirsty:
      return t.greetingPlantThirsty;
    case GreetingKind.weatherRain:
      return t.greetingWeatherRain;
    case GreetingKind.weatherThunderstorm:
      return t.greetingWeatherThunderstorm;
    case GreetingKind.weatherSnow:
      return t.greetingWeatherSnow;
    case GreetingKind.weatherFog:
      return t.greetingWeatherFog;
    case GreetingKind.weatherHot:
      return t.greetingWeatherHot(greeting.temperatureC!);
  }
}

// ---------------------------------------------------------------------------
// Bento tiles
// ---------------------------------------------------------------------------

enum _TileLayout { tall, compact, wide }

class _Tile extends StatelessWidget {
  const _Tile({
    required this.layout,
    required this.label,
    required this.image,
    required this.onTap,
    this.fill = _cream,
    this.dark = false,
  });

  final _TileLayout layout;
  final String label;
  final String image;
  final VoidCallback onTap;
  final Color fill;

  /// Dark (teal) tile: cream text, image sits in a cream frame.
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final ink = dark ? _cream : _ink;

    final Widget content = switch (layout) {
      _TileLayout.tall => Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: _ArrowDot(dark: dark),
              ),
              Expanded(child: Image.asset(image, fit: BoxFit.contain)),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppTextStyles.inter(16, w: FontWeight.w800, c: ink),
              ),
            ],
          ),
        ),
      _TileLayout.compact => Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(child: Image.asset(image, fit: BoxFit.contain)),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: AppTextStyles.inter(14, w: FontWeight.w800, c: ink),
                ),
              ),
            ],
          ),
        ),
      _TileLayout.wide => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: dark ? _cream : Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Image.asset(image, fit: BoxFit.contain),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  style: AppTextStyles.inter(17, w: FontWeight.w800, c: ink),
                ),
              ),
              const SizedBox(width: 8),
              _ArrowDot(dark: dark),
            ],
          ),
        ),
    };

    return Material(
      color: fill,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: dark
              ? _cream.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.7),
          width: 2,
        ),
      ),
      child: InkWell(onTap: onTap, child: content),
    );
  }
}

class _ArrowDot extends StatelessWidget {
  const _ArrowDot({required this.dark});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dark ? _cream : _teal,
      ),
      child: Icon(
        Icons.arrow_forward_rounded,
        size: 18,
        color: dark ? _teal : _cream,
      ),
    );
  }
}
