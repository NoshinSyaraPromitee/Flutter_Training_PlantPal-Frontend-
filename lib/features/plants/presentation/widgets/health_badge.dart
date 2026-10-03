import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/plant.dart';
import 'health_ring.dart';

/// Health pill driven by the server's score and state.
class HealthBadge extends StatelessWidget {
  const HealthBadge({
    super.key,
    required this.health,
    required this.state,
  });

  final int health;
  final HealthState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final color = healthColor(state);
    final text = switch (state) {
      HealthState.critical => l10n.healthCritical(health),
      HealthState.needsCare => l10n.healthNeedsCare(health),
      HealthState.okay => l10n.healthOkay(health),
      HealthState.thriving => l10n.healthHealthy(health),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppTextStyles.inter(
          12,
          w: FontWeight.w700,
          c: Colors.white,
        ),
      ),
    );
  }
}
