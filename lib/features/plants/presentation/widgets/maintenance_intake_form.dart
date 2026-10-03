import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/theme/app_text_styles.dart';
import 'maintenance_colors.dart';

/// Plant name / type / age intake form with the "Create My Roadmap" button.
/// Reports the submitted name + type up via [onSubmit]; keeps its own
/// text-editing state internally.
class MaintenanceIntakeForm extends StatefulWidget {
  const MaintenanceIntakeForm({super.key, required this.onSubmit});

  final void Function(String name, String type) onSubmit;

  @override
  State<MaintenanceIntakeForm> createState() => _MaintenanceIntakeFormState();
}

class _MaintenanceIntakeFormState extends State<MaintenanceIntakeForm> {
  final _nameCtrl = TextEditingController();
  final _typeCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _typeCtrl.dispose();
    _ageCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Give your plant a name first.')),
      );
      return;
    }
    widget.onSubmit(_nameCtrl.text.trim(), _typeCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFEFC48C), borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Container(
            width: 130,
            height: 130,
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(color: Color(0xFFCFE8B8), shape: BoxShape.circle),
            child: Image.asset('assets/images/maintenance_cactus.png', fit: BoxFit.contain),
          ),
          const SizedBox(height: 20),
          _label('Name of the Plant'),
          _field(_nameCtrl, 'Value'),
          const SizedBox(height: 16),
          _label('Types of Plant'),
          _field(_typeCtrl, 'Water based, Ornamental etc'),
          const SizedBox(height: 16),
          _label('How old is the plant?'),
          _field(_ageCtrl, 'Seed, Seedling, Mature...', maxLines: 3),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonOrange,
              foregroundColor: Colors.black87,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Create My Roadmap', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _label(String t) => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(t, style: AppTextStyles.inter(14, w: FontWeight.w700, c: kMaintenanceInk)),
        ),
      );

  Widget _field(TextEditingController c, String hint, {int maxLines = 1}) => TextField(
        controller: c,
        style: const TextStyle(color: kMaintenanceInk, fontSize: 14),
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: kMaintenanceInkMuted),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      );
}