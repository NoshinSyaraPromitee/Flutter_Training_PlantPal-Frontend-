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
  bool _identifying = false;

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

  Future<void> _identifyWithAi() async {
    var bytes = _imageBytes;
    if (bytes == null) {
      bytes = await pickPhoto(context);
      if (bytes == null) return;
      setState(() => _imageBytes = bytes);
    }

    setState(() => _identifying = true);

    final res =
        await ref.read(plantsControllerProvider).identifyPlant(bytes);

    if (!mounted) return;
    setState(() => _identifying = false);

    if (res != null) {
      setState(() {
        if (res.species.isNotEmpty) _species.text = res.species;
        if (res.suggestedNickname.isNotEmpty) {
          _nickname.text = res.suggestedNickname;
        } else if (_nickname.text.isEmpty && res.species.isNotEmpty) {
          _nickname.text = res.species.split(' ').first;
        }
        if (res.location.isNotEmpty) _location.text = res.location;
        if (res.sunlight.isNotEmpty) _sunlight.text = res.sunlight;
        if (res.wateringFrequencyDays > 0) {
          _days.text = res.wateringFrequencyDays.toString();
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Identified as ${res.species}! Nickname and care specs auto-filled.',
          ),
          backgroundColor: AppColors.greenPrimary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not identify plant. You can still enter details manually.'),
        ),
      );
    }
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
              height: 190,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: AppColors.greenPrimary.withValues(alpha: 0.2),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: _imageBytes != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.memory(
                          _imageBytes!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        Positioned(
                          right: 12,
                          bottom: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit, color: Colors.white, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'Change Photo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: _identifying
                  ? 'Analyzing with AI Botanist...'
                  : l10n.autoFillAiScanButton,
              variant: AppButtonVariant.orange,
              trailingIcon: _identifying ? null : Icons.auto_awesome,
              onPressed: _identifying ? null : _identifyWithAi,
            ),
          ),
          if (_identifying)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: LinearProgressIndicator(
                color: AppColors.greenPrimary,
                backgroundColor: AppColors.surfaceGreen,
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
          const SizedBox(height: 16),
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