import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/app_back_button.dart';
import 'package:plantpal/core/widgets/gradient_background.dart';

/// Standard screen: gradient + safe area + back arrow / title / trailing action.
class AppScreen extends StatelessWidget {
  const AppScreen({
    super.key,
    required this.title,
    required this.child,
    this.showBack = true,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  final String title;
  final Widget child;
  final bool showBack;
  final Widget? trailing;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Row(children: [
                SizedBox(width: 48, child: showBack ? const AppBackButton() : null),
                Expanded(
                  child: Text(title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.screenTitle.copyWith(fontSize: 30)),
                ),
                SizedBox(width: 48, child: trailing),
              ]),
            ),
            Expanded(child: Padding(padding: padding, child: child)),
          ]),
        ),
      ),
    );
  }
}