import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'maintenance_colors.dart';

/// "Set Alarm" card with tappable hour/minute steppers and an AM/PM toggle.
class SetAlarmCard extends StatefulWidget {
  const SetAlarmCard({super.key});

  @override
  State<SetAlarmCard> createState() => _SetAlarmCardState();
}

class _SetAlarmCardState extends State<SetAlarmCard> {
  int _hour = 20;
  int _minute = 0;
  bool _pm = true;

  void _adjustHour(int d) => setState(() => _hour = _hour + d > 12 ? 1 : (_hour + d < 1 ? 12 : _hour + d));
  void _adjustMinute(int d) =>
      setState(() => _minute = (_minute + d) > 59 ? 0 : ((_minute + d) < 0 ? 59 : _minute + d));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFD7DCC7), borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text('Set Alarm', style: AppTextStyles.inter(14, w: FontWeight.w700, c: kMaintenanceInk))),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _timeBox(_hour.toString().padLeft(2, '0'), () => _adjustHour(1), () => _adjustHour(-1)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text(':', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kMaintenanceInk)),
              ),
              _timeBox(_minute.toString().padLeft(2, '0'), () => _adjustMinute(1), () => _adjustMinute(-1)),
              const SizedBox(width: 12),
              Column(mainAxisSize: MainAxisSize.min, children: [
                _ampm('AM', !_pm),
                const SizedBox(height: 4),
                _ampm('PM', _pm),
              ]),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => setState(() {
                  _hour = 20;
                  _minute = 0;
                  _pm = true;
                }),
                child: const Text('Cancel', style: TextStyle(color: kMaintenanceInk)),
              ),
              TextButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Alarm set for ${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')} ${_pm ? 'PM' : 'AM'}',
                    ),
                  ),
                ),
                child: Text('OK', style: TextStyle(color: AppColors.greenPrimary, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeBox(String value, VoidCallback onUp, VoidCallback onDown) => Container(
        width: 56,
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                iconSize: 16,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onUp,
                icon: const Icon(Icons.keyboard_arrow_up, color: kMaintenanceInk)),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kMaintenanceInk)),
            IconButton(
                iconSize: 16,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onDown,
                icon: const Icon(Icons.keyboard_arrow_down, color: kMaintenanceInk)),
          ],
        ),
      );

  Widget _ampm(String label, bool selected) => GestureDetector(
        onTap: () => setState(() => _pm = label == 'PM'),
        child: Container(
          width: 40,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
              color: selected ? AppColors.greenPrimary : Colors.white, borderRadius: BorderRadius.circular(6)),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700, color: selected ? Colors.white : Colors.black87)),
        ),
      );
}