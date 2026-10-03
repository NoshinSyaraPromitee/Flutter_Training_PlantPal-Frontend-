import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as p;

import '../../../../app/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_screen.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/photo_picker_sheet.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../gamification/presentation/providers/points_provider.dart';
import '../../domain/model/plant.dart';
import '../utils/due_text.dart';
import '../utils/plant_choices.dart';
import '../widgets/choice_chips_row.dart';
import '../widgets/info_box.dart';

/// When the plant was last watered (Add Plant, step 2).
enum _LastWatered { today, yesterday, date, never }

/// What the user chose on the success dialog.
enum _AfterSave { view, another, done }

/// Add a plant in three steps: photo / identify, confirm details, care plan
/// preview (PLAN.md 3.1-3.4).
class AddPlantScreen extends ConsumerStatefulWidget {
  const AddPlantScreen({super.key, this.startWithScan = false});

  /// Opens the photo picker and identifies the plant right away
  /// ("Scan to add" on the empty My Plants screen).
  final bool startWithScan;

  @override
  ConsumerState<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends ConsumerState<AddPlantScreen> {
  static const _lastStep = 2;
  static const _firstPlantPoints = 50;

  final _nickname = TextEditingController();
  final _species = TextEditingController();

  int _step = 0;
  Uint8List? _imageBytes;

  String _location = '';
  bool _outdoor = false;
  String _light = '';
  String _stage = '';
  int _days = 7;
  _LastWatered _lastWatered = _LastWatered.today;
  DateTime? _pickedDate;

  /// Kept from the AI identify result.
  int _waterMl = 0;
  String _careTips = '';

  bool _identifying = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.startWithScan) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _pickAndIdentify();
      });
    }
  }

  @override
  void dispose() {
    _nickname.dispose();
    _species.dispose();
    super.dispose();
  }

  // ---- step 1: photo + identify ----

  Future<void> _pickPhoto() async {
    final bytes = await pickPhoto(context);
    if (bytes == null || !mounted) return;
    setState(() => _imageBytes = bytes);
  }

  Future<void> _pickAndIdentify() async {
    if (_imageBytes == null) {
      await _pickPhoto();
      if (_imageBytes == null) return;
    }
    await _identify();
  }

  Future<void> _identify() async {
    final bytes = _imageBytes;
    if (bytes == null) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _identifying = true);
    final res = await ref.read(plantsControllerProvider).identifyPlant(bytes);
    if (!mounted) return;
    setState(() => _identifying = false);

    if (res == null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.identifyFailedSnackbar)));
      setState(() => _step = 1);
      return;
    }

    setState(() {
      if (res.species.isNotEmpty) _species.text = res.species;
      if (res.suggestedNickname.isNotEmpty) {
        _nickname.text = res.suggestedNickname;
      } else if (_nickname.text.isEmpty && res.species.isNotEmpty) {
        _nickname.text = res.species.split(' ').first;
      }
      if (res.location.isNotEmpty) {
        final m = PlantChoices.matchLocation(res.location);
        _location = m.isNotEmpty ? m : res.location;
        _outdoor = PlantChoices.isOutdoorLocation(_location);
      }
      if (res.sunlight.isNotEmpty) {
        final m = PlantChoices.matchLight(res.sunlight);
        _light = m.isNotEmpty ? m : res.sunlight;
      }
      if (res.wateringFrequencyDays > 0) _days = res.wateringFrequencyDays;
      if (res.waterAmountMl > 0) _waterMl = res.waterAmountMl;
      _careTips = res.careTips;
      _step = 1;
    });
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.identifiedSnackbar(res.species)),
        backgroundColor: AppColors.greenPrimary,
      ),
    );
  }

  // ---- step 2: details ----

  DateTime? get _lastWateredAt {
    final now = DateTime.now();
    return switch (_lastWatered) {
      _LastWatered.today => now,
      _LastWatered.yesterday => now.subtract(const Duration(days: 1)),
      _LastWatered.date => _pickedDate == null
          ? null
          : DateTime(_pickedDate!.year, _pickedDate!.month, _pickedDate!.day,
              now.hour, now.minute),
      _LastWatered.never => null,
    };
  }

  Future<void> _chooseLastWatered(String v) async {
    final choice = _LastWatered.values.firstWhere(
      (e) => e.name == v,
      orElse: () => _LastWatered.today,
    );
    if (choice != _LastWatered.date) {
      setState(() => _lastWatered = choice);
      return;
    }
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _pickedDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _pickedDate = picked;
      _lastWatered = _LastWatered.date;
    });
  }

  NewPlant _buildPlant() => NewPlant(
        nickname: _nickname.text,
        species: _species.text,
        location: _location,
        sunlight: _light,
        outdoor: _outdoor,
        ageStage: _stage,
        wateringFrequencyDays: _days,
        lastWatered: _lastWateredAt,
        imageBytes: _imageBytes,
        waterAmountMl: _waterMl,
        careTips: _careTips,
      );

  void _goToPlan() {
    final err = _buildPlant().validate();
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _step = 2);
  }

  // ---- step 3: save ----

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final controller = ref.read(plantsControllerProvider);
    final points = p.Provider.of<PointsController>(context, listen: false);
    final plant = _buildPlant();
    final wasEmpty = controller.loaded && controller.plants.isEmpty;

    setState(() => _saving = true);
    final err = await controller.add(plant);
    if (!mounted) return;
    setState(() => _saving = false);

    if (err != null) {
      messenger.showSnackBar(SnackBar(content: Text(err)));
      return;
    }

    final bonus = wasEmpty &&
        await points.awardOnce('first_plant', _firstPlantPoints);
    if (!mounted) return;

    final created = controller.plants.isEmpty ? null : controller.plants.first;
    final choice = await showDialog<_AfterSave>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SavedDialog(
        title: l10n.plantAddedSnackbar(plant.nickname.trim()),
        firstPlant: bonus,
        points: _firstPlantPoints,
      ),
    );
    if (!mounted) return;

    switch (choice) {
      case _AfterSave.view when created != null:
        router.pushReplacement('/plants/${created.id}');
      case _AfterSave.another:
        _reset();
      default:
        if (router.canPop()) {
          router.pop();
        } else {
          router.go('/plants');
        }
    }
  }

  void _reset() {
    setState(() {
      _step = 0;
      _imageBytes = null;
      _nickname.clear();
      _species.clear();
      _location = '';
      _outdoor = false;
      _light = '';
      _stage = '';
      _days = 7;
      _lastWatered = _LastWatered.today;
      _pickedDate = null;
      _waterMl = 0;
      _careTips = '';
    });
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  // ---- UI ----

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 18),
        child: Text(
          t,
          style: AppTextStyles.inter(
            15,
            w: FontWeight.w700,
            c: AppColors.greenPrimary,
          ),
        ),
      );

  Widget _stepHeader(AppLocalizations l10n) {
    final names = [l10n.addStepPhoto, l10n.addStepDetails, l10n.addStepPlan];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        label: l10n.addStepProgress(_step + 1, _lastStep + 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                for (var i = 0; i <= _lastStep; i++) ...[
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: i <= _step
                            ? AppColors.greenPrimary
                            : AppColors.greenPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  if (i < _lastStep) const SizedBox(width: 6),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${l10n.addStepProgress(_step + 1, _lastStep + 1)} · ${names[_step]}',
              style: AppTextStyles.inter(13, c: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _photoBox(AppLocalizations l10n, {required double height}) {
    return GestureDetector(
      onTap: _identifying ? null : _pickPhoto,
      child: Container(
        height: height,
        width: double.infinity,
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
                  Image.memory(_imageBytes!, fit: BoxFit.cover),
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.edit, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            l10n.changePhotoLabel,
                            style: const TextStyle(
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
    );
  }

  Widget _photoStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.addPhotoStepTitle,
          style: AppTextStyles.inter(22, w: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.addPhotoStepBody,
          style: AppTextStyles.inter(14, c: AppColors.textMuted, h: 1.4),
        ),
        const SizedBox(height: 16),
        _photoBox(l10n, height: 240),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: _identifying
                ? l10n.addIdentifyingLabel
                : l10n.autoFillAiScanButton,
            variant: AppButtonVariant.orange,
            trailingIcon: _identifying ? null : Icons.auto_awesome,
            onPressed: _identifying ? null : _pickAndIdentify,
          ),
        ),
        if (_identifying)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: LinearProgressIndicator(
              color: AppColors.greenPrimary,
              backgroundColor: AppColors.surfaceGreen,
            ),
          ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: _identifying ? null : () => setState(() => _step = 1),
            child: Text(l10n.addEnterManually),
          ),
        ),
      ],
    );
  }

  /// Fixed options, plus the current value when it is free text that matched
  /// none of them (an older or AI-written value), so nothing is lost.
  List<ChoiceOption> _options(
    AppLocalizations l10n,
    List<String> values,
    String current,
  ) {
    final all = [
      ...values,
      if (current.isNotEmpty && !values.contains(current)) current,
    ];
    return [for (final v in all) ChoiceOption(v, PlantChoices.label(l10n, v))];
  }

  Widget _detailsStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_imageBytes != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 110,
              width: double.infinity,
              child: Image.memory(_imageBytes!, fit: BoxFit.cover),
            ),
          ),
        ],
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
          options: _options(l10n, PlantChoices.lights, _light),
          selected: _light,
          clearable: true,
          onChanged: (v) => setState(() => _light = v),
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
        _label(l10n.lastWateredLabel),
        ChoiceChipsRow(
          selected: _lastWatered.name,
          onChanged: _chooseLastWatered,
          options: [
            ChoiceOption(_LastWatered.today.name, l10n.todayLabel),
            ChoiceOption(_LastWatered.yesterday.name, l10n.yesterdayLabel),
            ChoiceOption(
              _LastWatered.date.name,
              _lastWatered == _LastWatered.date && _pickedDate != null
                  ? shortDate(_pickedDate!)
                  : l10n.pickDateChip,
              icon: Icons.calendar_today,
            ),
            ChoiceOption(_LastWatered.never.name, l10n.notYetChip),
          ],
        ),
      ],
    );
  }

  Widget _planRow(IconData icon, Color color, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.inter(12, c: AppColors.textMuted),
                ),
                Text(
                  value,
                  style: AppTextStyles.inter(15, w: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _planStep(AppLocalizations l10n) {
    final last = _lastWateredAt;
    final firstDays =
        last == null ? 0 : calendarDaysUntil(last.add(Duration(days: _days)));
    final env = [
      if (_location.isNotEmpty) PlantChoices.label(l10n, _location),
      if (_light.isNotEmpty) PlantChoices.label(l10n, _light),
      if (_stage.isNotEmpty) PlantChoices.label(l10n, _stage),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.planPreviewTitle,
          style: AppTextStyles.inter(22, w: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (_imageBytes != null)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.memory(
                          _imageBytes!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nickname.text.trim(),
                          style: AppTextStyles.inter(18, w: FontWeight.w800),
                        ),
                        Text(
                          _species.text.trim(),
                          style: AppTextStyles.inter(
                            13,
                            c: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _back,
                    child: Text(l10n.planEditDetails),
                  ),
                ],
              ),
              const Divider(height: 24),
              _planRow(
                Icons.water_drop,
                AppColors.waterBlue,
                l10n.scheduleWater,
                [
                  l10n.scheduleEvery(_days),
                  if (_waterMl > 0) l10n.planWaterAmount(_waterMl),
                ].join(' · '),
              ),
              _planRow(
                Icons.event,
                AppColors.greenPrimary,
                l10n.planFirstWatering,
                last == null ? l10n.todayLabel : dueText(l10n, firstDays),
              ),
              if (env.isNotEmpty)
                _planRow(
                  Icons.wb_sunny,
                  AppColors.sunAmber,
                  l10n.locationLabel,
                  env.join(' · '),
                ),
            ],
          ),
        ),
        if (_careTips.trim().isNotEmpty) ...[
          const SizedBox(height: 14),
          InfoBox(
            icon: Icons.lightbulb_outline,
            text: _careTips.trim(),
            color: AppColors.sunAmber,
          ),
        ],
        const SizedBox(height: 14),
        Text(
          l10n.planFeedingNote,
          style: AppTextStyles.inter(13, c: AppColors.textMuted, h: 1.4),
        ),
      ],
    );
  }

  /// Bottom action bar: Back + the step's main action.
  Widget _actions(AppLocalizations l10n) {
    final (String label, IconData icon, VoidCallback? onTap) = switch (_step) {
      0 => (l10n.nextButton, Icons.arrow_forward, () => setState(() => _step = 1)),
      1 => (l10n.reviewPlanButton, Icons.arrow_forward, _goToPlan),
      _ => (
          _saving ? l10n.savingLabel : l10n.savePlantButton,
          Icons.save,
          _saving ? null : _save,
        ),
    };

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        children: [
          if (_step > 0) ...[
            AppButton(
              label: l10n.backButton,
              variant: AppButtonVariant.outline,
              onPressed: _saving ? null : _back,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: AppButton(
              label: label,
              trailingIcon: icon,
              onPressed: _identifying ? null : onTap,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: AppScreen(
        title: l10n.addPlantTitle,
        child: Column(
          children: [
            _stepHeader(l10n),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16, top: 8),
                child: switch (_step) {
                  0 => _photoStep(l10n),
                  1 => _detailsStep(l10n),
                  _ => _planStep(l10n),
                },
              ),
            ),
            _actions(l10n),
          ],
        ),
      ),
    );
  }
}

/// "Plant added" celebration with what to do next.
class _SavedDialog extends StatelessWidget {
  const _SavedDialog({
    required this.title,
    required this.firstPlant,
    required this.points,
  });

  final String title;
  final bool firstPlant;
  final int points;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            size: 64,
            color: AppColors.greenPrimary,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.inter(18, w: FontWeight.w800),
          ),
          if (firstPlant) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.sunAmber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.eco, color: AppColors.greenPrimary),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '${l10n.firstSproutUnlocked}  ${l10n.pointsEarned(points)}',
                      style: AppTextStyles.inter(13, w: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowButtonSpacing: 4,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, _AfterSave.another),
          child: Text(l10n.addAnotherButton),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _AfterSave.done),
          child: Text(l10n.closeButton),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _AfterSave.view),
          child: Text(l10n.viewPlantButton),
        ),
      ],
    );
  }
}
