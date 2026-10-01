import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

/// Gold coin + dark pill: label passed from parent (already formatted via l10n).
class PointsPill extends StatelessWidget {
  const PointsPill({
    super.key,
    required this.points,
    required this.taka,
    required this.label,
  });

  final int points;
  final int taka;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 13),
          padding: const EdgeInsets.fromLTRB(20, 3, 10, 3),
          decoration: BoxDecoration(
            color: const Color(0xFF7A4B12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: AppTextStyles.inter(
              11,
              w: FontWeight.w800,
              c: const Color(0xFFFCE8B8),
            ),
          ),
        ),
        const Positioned(
          left: 0,
          top: -4,
          child: _Coin(),
        ),
      ],
    );
  }
}

class _Coin extends StatelessWidget {
  const _Coin();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFE04A),
            Color(0xFFF5A300),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 17,
          height: 17,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFFF2A8),
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.star_rounded,
            size: 11,
            color: Color(0xFFFFF2A8),
          ),
        ),
      ),
    );
  }
}

/// Gold-bordered speech bubble with a tail at the bottom-left.
class SpeechBubble extends StatelessWidget {
  const SpeechBubble({
    super.key,
    required this.text,
    this.onTap,
  });

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: const _BubblePainter(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            11,
            10,
            11,
            20,
          ),
          child: Text(
            text,
            style: AppTextStyles.inter(
              10,
              w: FontWeight.w800,
              h: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  const _BubblePainter();

  static const double tail = 10;
  static const double border = 5;

  @override
  void paint(Canvas canvas, Size size) {
    final gold = Paint()..color = const Color(0xFFB87914);
    final cream = Paint()..color = const Color(0xFFFFF6DC);

    final body = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height - tail,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        body,
        const Radius.circular(12),
      ),
      gold,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        body.deflate(border),
        const Radius.circular(3),
      ),
      cream,
    );

    final path = Path()
      ..moveTo(0, body.bottom - 6)
      ..lineTo(0, size.height)
      ..lineTo(18, body.bottom - 6)
      ..close();

    canvas.drawPath(path, gold);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Outlined rounded tile with an illustration and a label underneath.
class MainMenuTile extends StatelessWidget {
  const MainMenuTile({
    super.key,
    required this.imageAsset,
    required this.label,
    required this.onTap,
  });

  final String imageAsset;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.white.withValues(alpha: 0.35),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Color(0xFFB9C4B3),
              ),
            ),
            child: InkWell(
              onTap: onTap,
              child: SizedBox(
                width: 100,
                height: 86,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.inter(
              13,
              c: const Color(0xFF6F8068),
            ),
          ),
        ],
      ),
    );
  }
}

/// Camera / Chat with expert / Back — labels passed from parent.
class MainMenuBottomBar extends StatelessWidget {
  const MainMenuBottomBar({
    super.key,
    required this.cameraLabel,
    required this.chatLabel,
    required this.backLabel,
    required this.onCamera,
    required this.onChat,
    required this.onBack,
  });

  final String cameraLabel;
  final String chatLabel;
  final String backLabel;
  final VoidCallback onCamera;
  final VoidCallback onChat;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFD3D9CC),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BarItem(
                label: cameraLabel,
                icon: const Icon(
                  Icons.photo_camera_outlined,
                  size: 22,
                  color: Color(0xFF222222),
                ),
                onTap: onCamera,
              ),
              _BarItem(
                label: chatLabel,
                pill: const Color(0xFFB4BCAE),
                icon: Opacity(
                  opacity: 0.45,
                  child: Image.asset(
                    'assets/images/chat_bot_icon.png',
                    width: 22,
                    height: 22,
                  ),
                ),
                onTap: onChat,
              ),
              _BarItem(
                label: backLabel,
                icon: const Icon(
                  Icons.arrow_back,
                  size: 22,
                  color: Color(0xFF222222),
                ),
                onTap: onBack,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.pill = const Color(0xFFC3CBBB),
  });

  final String label;
  final Widget icon;
  final VoidCallback onTap;
  final Color pill;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: pill,
                borderRadius: BorderRadius.circular(16),
              ),
              child: icon,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.inter(
                11,
                w: FontWeight.w600,
                c: const Color(0xFF4A4F44),
              ),
            ),
          ],
        ),
      ),
    );
  }
}