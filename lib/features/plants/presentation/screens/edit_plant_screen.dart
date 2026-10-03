import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/plant_image.dart';
import '../../../../core/widgets/photo_picker_sheet.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../l10n/app_localizations.dart';
import '../utils/plant_choices.dart';
import '../widgets/choice_chips_row.dart';

class EditPlantScreen extends ConsumerStatefulWidget {
  const EditPlantScreen({super.key, required this.id});
  final String id;
  @override
  ConsumerState<EditPlantScreen> createState() => _EditPlantScreenState();
}

class _EditPlantScreenState extends ConsumerState<EditPlantScreen> {
  final _nickname = TextEditingController();
  final _species = TextEditingController();
  String _location = '';
  bool _outdoor = false;
  String _sunlight = '';
  String _stage = '';
  int _days = 7;
  Uint8List? _newImageBytes;
  bool _saving = false;
  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;
    final p = ref.read(plantsControllerProvider).byId(widget.id);
    if (p != null) {
      _nickname.text = p.nickname;
      _species.text = p.species;
      _location = p.location;
      _outdoor = p.isOutdoor;
      _sunlight = p.sunlight;
      _stage = p.ageStage;
      _days = p.wateringFrequencyDays;
    }
  }

  @override
  void dispose() {
    _nickname.dispose();
    _species.dispose();
    super.dispose();
  }

  List<ChoiceOption> _options(
    AppLocalizations l10n,
    List<String> values,
    String current,
  ) {
    final list = [
      for (final v in values) ChoiceOption(v, PlantChoices.label(l10n, v)),
    ];
    if (current.isNotEmpty && !values.contains(current)) {
      list.add(ChoiceOption(current, current));
    }
    return list;
  }

  Future<void> _pickPhoto() async {
    final bytes = await pickPhoto(context);
    if (bytes != null) {
      setState(() => _newImageBytes = bytes);
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);

    if (_newImageBytes != null) {
      await ref
          .read(plantsControllerProvider)
          .uploadImage(widget.id, _newImageBytes!);
    }

    final err = await ref.read(plantsControllerProvider).updateDetails(
          id: widget.id,
          nickname: _nickname.text,
          species: _species.text,
          location: _location,
          sunlight: _sunlight,
          wateringFrequencyDays: _days,
          ageStage: _stage,
          outdoor: _outdoor,
        );

    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(err ?? l10n.plantSavedSnackbar)),
    );
    if (err == null) context.pop();
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteConfirmTitle),
        content: Text(l10n.deleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.deleteButton,
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await ref.read(plantsControllerProvider).remove(widget.id);
    if (mounted) context.go('/plants');
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
    final plant = ref.watch(plantsControllerProvider).byId(widget.id);
    if (plant == null) {
      return AppScreen(
        title: l10n.editPlantTitle,
        child: ErrorView(message: l10n.plantNotFoundMessage),
      );
    }

    return AppScreen(
      title: l10n.editPlantTitle,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          AppCard(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _pickPhoto,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: _newImageBytes != null
                            ? Image.memory(
                                _newImageBytes!,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                              )
                            : plant.imageUrl.isNotEmpty
                                ? PlantImage(
                                    plant.imageUrl,
                                    width: 64,
                                    height: 64,
                                    radius: 30,
                                  )
                                : Container(
                                    width: 64,
                                    height: 64,
                                    color: AppColors.surfaceGreen,
                                    child: const Icon(
                                      Icons.local_florist,
                                      color: AppColors.greenPrimary,
                                      size: 32,
                                    ),
                                  ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.greenPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.nickname.isEmpty
                            ? l10n.noNicknameLabel
                            : plant.nickname,
                        style: AppTextStyles.inter(17, w: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: _pickPhoto,
                        icon: const Icon(
                          Icons.photo_library_outlined,
                          size: 15,
                          color: AppColors.greenPrimary,
                        ),
                        label: const Text(
                          'Update Photo',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.greenPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _label(l10n.nicknameLabel),
          AppTextField(controller: _nickname, hint: l10n.nicknameHint),
          _label(l10n.plantSpeciesLabel),
          AppTextField(controller: _species, hint: l10n.speciesHint),
          _label(l10n.locationLabel),
          ChoiceChipsRow(
            options: _options(l10n, PlantChoices.locations, _location),
            selected: _location,
            clearable: true,
            onChanged: (v) => setState(() {
              _location = v;
              if (v.isNotEmpty) _outdoor = PlantChoices.isOutdoorLocation(v);
            }),
          ),
          _label(l10n.plantPlacementLabel),
          ChoiceChipsRow(
            options: [
              ChoiceOption('indoor', l10n.locationIndoor, icon: Icons.home_outlined),
              ChoiceOption('outdoor', l10n.locationOutdoor, icon: Icons.park_outlined),
            ],
            selected: _outdoor ? 'outdoor' : 'indoor',
            onChanged: (v) => setState(() => _outdoor = v == 'outdoor'),
          ),
          _label(l10n.careMetricSunlight),
          ChoiceChipsRow(
            options: _options(l10n, PlantChoices.lights, _sunlight),
            selected: _sunlight,
            clearable: true,
            onChanged: (v) => setState(() => _sunlight = v),
          ),
          _label(l10n.plantAgeLabel),
          ChoiceChipsRow(
            options: _options(l10n, PlantChoices.stages, _stage),
            selected: _stage,
            clearable: true,
            onChanged: (v) => setState(() => _stage = v),
          ),
          _label(l10n.waterFrequencyLabel),
          IntervalStepper(
            days: _days,
            label: l10n.scheduleEvery(_days),
            onChanged: (v) => setState(() => _days = v),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: _saving ? l10n.savingLabel : l10n.savePlantButton,
              trailingIcon: Icons.save,
              onPressed: _saving ? null : _save,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _delete,
              icon: const Icon(Icons.delete, size: 18),
              label: Text(l10n.deletePlantButton),
            ),
          ),
        ],
      ),
    );
  }
}

