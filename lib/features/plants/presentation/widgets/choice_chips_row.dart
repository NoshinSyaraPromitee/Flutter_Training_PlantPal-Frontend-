import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// One tappable option of a [ChoiceChipsRow].
class ChoiceOption {
  const ChoiceOption(this.value, this.label, {this.icon});
  final String value;
  final String label;
  final IconData? icon;
}

/// A single-choice row of pill chips (location, light, stage, last watered).
/// Tapping the selected chip again clears it when [clearable] is true.
class ChoiceChipsRow extends StatelessWidget {
  const ChoiceChipsRow({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.clearable = false,
  });

  final List<ChoiceOption> options;
  final String selected;
  final ValueChanged<String> onChanged;
  final bool clearable;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in options)
          Semantics(
            button: true,
            selected: o.value == selected,
            label: o.label,
            child: ChoiceChip(
              avatar: o.icon == null
                  ? null
                  : Icon(
                      o.icon,
                      size: 18,
                      color: o.value == selected
                          ? Colors.white
                          : AppColors.greenPrimary,
                    ),
              label: Text(
                o.label,
                style: AppTextStyles.inter(
                  14,
                  w: FontWeight.w600,
                  c: o.value == selected ? Colors.white : AppColors.greenPrimary,
                ),
              ),
              selected: o.value == selected,
              showCheckmark: false,
              selectedColor: AppColors.greenPrimary,
              backgroundColor: Colors.white,
              side: BorderSide(
                color: AppColors.greenPrimary.withValues(alpha: 0.25),
              ),
              onSelected: (on) =>
                  onChanged(on ? o.value : (clearable ? '' : o.value)),
            ),
          ),
      ],
    );
  }
}

/// "−  Every 7 days  +" stepper for the watering interval.
class IntervalStepper extends StatelessWidget {
  const IntervalStepper({
    super.key,
    required this.days,
    required this.label,
    required this.onChanged,
    this.min = 1,
    this.max = 60,
  });

  final int days;

  /// Localised text for the current value, e.g. "Every 7 days".
  final String label;
  final ValueChanged<int> onChanged;
  final int min, max;

  @override
  Widget build(BuildContext context) {
    Widget btn(IconData icon, bool enabled, VoidCallback onTap, String tip) =>
        IconButton.filledTonal(
          tooltip: tip,
          onPressed: enabled ? onTap : null,
          icon: Icon(icon),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.greenPrimary,
            minimumSize: const Size(48, 48),
          ),
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        btn(Icons.remove, days > min, () => onChanged(days - 1), '−'),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 120),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.inter(
              16,
              w: FontWeight.w700,
              c: AppColors.greenPrimary,
            ),
          ),
        ),
        btn(Icons.add, days < max, () => onChanged(days + 1), '+'),
      ],
    );
  }
}
