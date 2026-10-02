import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/features/home/domain/mascot_character.dart';
import 'package:plantpal/features/home/presentation/providers/mascot_provider.dart';
import 'package:plantpal/features/home/presentation/widgets/menu_colors.dart';
import 'package:plantpal/features/home/presentation/widgets/rive_character.dart';

/// Rive mascot in a framed box with a name tag and arrows to switch character.
/// Width scales with the screen so the greeting bubble never gets squeezed.
class MenuHeroMascot extends ConsumerWidget {
  const MenuHeroMascot({super.key});

  static const double _border = 1.5;
  static const double _characterScale = 1.2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(mascotControllerProvider);
    final ctrl = ref.read(mascotControllerProvider.notifier);

    final screenW = MediaQuery.sizeOf(context).width;
    final width = (screenW * 0.34).clamp(104.0, 128.0);
    final height = width * 1.17;

    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width,
            height: height,
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
              border: Border.all(color: MenuColors.cream, width: _border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22 - _border),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: KeyedSubtree(
                  key: ValueKey(character),
                  child: Transform.scale(
                    scale: _characterScale,
                    child: RiveCharacter(character: character),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _Arrow(icon: Icons.chevron_left_rounded, onTap: ctrl.previous),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: MenuColors.cream,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    character.displayName,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.inter(
                      12,
                      w: FontWeight.w800,
                      c: MenuColors.ink,
                    ),
                  ),
                ),
              ),
              _Arrow(icon: Icons.chevron_right_rounded, onTap: ctrl.next),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final c in MascotCharacter.values)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MenuColors.cream
                        .withValues(alpha: c == character ? 1 : 0.35),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 24,
          height: 24,
          child: Icon(icon, size: 22, color: MenuColors.cream),
        ),
      );
}