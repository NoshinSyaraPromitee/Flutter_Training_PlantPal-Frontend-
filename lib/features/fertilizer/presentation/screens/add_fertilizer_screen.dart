import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plantpal/app/riverpod_providers.dart';
import 'package:plantpal/core/widgets/app_button.dart';
import 'package:plantpal/core/widgets/app_screen.dart';
import 'package:plantpal/features/fertilizer/presentation/widgets/fertilizer_form_fields.dart';

class AddFertilizerScreen extends ConsumerStatefulWidget {
  const AddFertilizerScreen({super.key});

  @override
  ConsumerState<AddFertilizerScreen> createState() =>
      _AddFertilizerScreenState();
}

class _AddFertilizerScreenState extends ConsumerState<AddFertilizerScreen> {
  final _name = TextEditingController();
  final _nutrient = TextEditingController();
  final _instructions = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _nutrient.dispose();
    _instructions.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);

    if (_name.text.trim().isEmpty || _instructions.text.trim().isEmpty) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Recipe name and instructions are required.'),
        ),
      );
      return;
    }

    setState(() => _saving = true);
    final name = _name.text.trim();

    final err = await ref.read(fertilizerControllerProvider).add(
          name: name,
          nutrient: _nutrient.text.trim(),
          instructions: _instructions.text.trim(),
        );

    if (!mounted) return;
    setState(() => _saving = false);

    if (err != null) {
      messenger.showSnackBar(SnackBar(content: Text(err)));
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text('$name added \u{1F331}')));
    context.pop();
  }

  @override
  Widget build(BuildContext context) => AppScreen(
        title: 'Add Fertilizer Recipe',
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            FertilizerFormSection(
              label: 'Recipe Name',
              controller: _name,
              hint: 'Coffee Ground Fertilizer',
            ),
            FertilizerFormSection(
              label: 'Main Nutrient (optional)',
              controller: _nutrient,
              hint: 'Nitrogen',
            ),
            FertilizerFormSection(
              label: 'Instructions (one step per line)',
              controller: _instructions,
              hint: 'Dry the grounds\nMix into soil\nApply every 2 weeks',
              maxLines: 6,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: _saving ? 'Saving...' : 'Save Recipe',
                trailingIcon: Icons.eco,
                onPressed: _saving ? null : _save,
              ),
            ),
          ],
        ),
      );
}
