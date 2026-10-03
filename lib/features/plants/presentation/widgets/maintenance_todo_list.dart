import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'package:plantpal/core/widgets/app_card.dart';
import 'maintenance_colors.dart';

/// Checkable care-task list. Keeps its own checked state — nothing to
/// persist yet, so the parent doesn't need to know which are ticked.
class MaintenanceTodoList extends StatefulWidget {
  const MaintenanceTodoList({super.key, this.sectionKey});

  final Key? sectionKey;

  @override
  State<MaintenanceTodoList> createState() => _MaintenanceTodoListState();
}

class _MaintenanceTodoListState extends State<MaintenanceTodoList> {
  static const _labels = ['Water the Plants', 'Use Potassium Fertilizer', 'Put them in the sun'];
  final _checked = [true, true, true];

  @override
  Widget build(BuildContext context) {
    return Column(
      key: widget.sectionKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle('To Do List'),
        AppCard(
          color: const Color(0xFFDCE9D0),
          child: Column(
            children: List.generate(_labels.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: const Color(0xFFB9A6E0),
                      child: Text('${i + 1}',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(_labels[i], style: AppTextStyles.inter(14, w: FontWeight.w600, c: kMaintenanceInk))),
                    Checkbox(
                      value: _checked[i],
                      activeColor: const Color(0xFF6C63FF),
                      onChanged: (v) => setState(() => _checked[i] = v ?? false),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}