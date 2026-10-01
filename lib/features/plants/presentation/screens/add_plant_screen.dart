import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/photo_picker_sheet.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/plant.dart';

class AddPlantScreen extends ConsumerStatefulWidget {
  const AddPlantScreen({super.key});

  @override
  ConsumerState<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends ConsumerState<AddPlantScreen> {
  final _nickname = TextEditingController();
  final _species = TextEditingController();
  final _location = TextEditingController();
  final _sunlight = TextEditingController();
  final _days = TextEditingController(text: '7');

  Uint8List? _imageBytes;
  bool _wateredToday = true;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [
      _nickname,
      _species,
      _location,
      _sunlight,
      _days,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);

    final plant = NewPlant(
      nickname: _nickname.text,
      species: _species.text,
      location: _location.text,
      sunlight: _sunlight.text,
      wateringFrequencyDays: int.tryParse(_days.text.trim()) ?? 7,
      lastWatered: _wateredToday ? DateTime.now() : null,
      imageBytes: _imageBytes,
    );

    setState(() => _saving = true);

    final err = await ref.read(plantsControllerProvider).add(plant);

    if (!mounted) return;

    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          err ?? l10n.plantAddedSnackbar(plant.nickname.trim()),
        ),
      ),
    );

    if (err == null) context.pop();
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6, top: 14),
        child: Text(
          t,
          style: AppTextStyles.inter(
            15,
            w: FontWeight.w700,
            c: AppColors.greenPrimary,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppScreen(
      title: l10n.addPlantTitle,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          GestureDetector(
            onTap: () async {
              final p = await pickPhoto(context);
              if (p != null) {
                setState(() => _imageBytes = p);
              }
            },
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              clipBehavior: Clip.antiAlias,
              child: _imageBytes != null
                  ? Image.memory(
                      _imageBytes!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_a_photo,
                          size: 56,
                          color: AppColors.greenPrimary,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.addPlantPhotoLabel,
                          style: AppTextStyles.inter(
                            16,
                            w: FontWeight.w700,
                            c: AppColors.greenPrimary,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          _label(l10n.nicknameLabel),
          AppTextField(
            controller: _nickname,
            hint: l10n.nicknameHint,
          ),
          _label(l10n.plantSpeciesLabel),
          AppTextField(
            controller: _species,
            hint: l10n.speciesHint,
          ),
          _label(l10n.locationLabel),
          AppTextField(
            controller: _location,
            hint: l10n.locationHint,
          ),
          _label(l10n.careMetricSunlight),
          AppTextField(
            controller: _sunlight,
            hint: l10n.sunlightMediumOption,
          ),
          _label(l10n.waterFrequencyLabel),
          AppTextField(
            controller: _days,
            hint: '3',
            keyboardType: TextInputType.number,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.greenPrimary,
            title: Text(
              l10n.wateredTodayCheckbox,
              style: AppTextStyles.inter(
                14,
                w: FontWeight.w600,
              ),
            ),
            value: _wateredToday,
            onChanged: (v) => setState(() => _wateredToday = v),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: l10n.autoFillAiScanButton,
              variant: AppButtonVariant.orange,
              trailingIcon: Icons.smart_toy,
              onPressed: () => context.go('/scan'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: _saving
                  ? l10n.savingLabel
                  : l10n.savePlantButton,
              trailingIcon: Icons.save,
              onPressed: _saving ? null : _save,
            ),
          ),
        ],
      ),
    );
  }
}