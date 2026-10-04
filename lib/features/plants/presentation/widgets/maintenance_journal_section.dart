import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:plantpal/core/theme/app_colors.dart';
import 'package:plantpal/core/widgets/app_card.dart';
import 'package:plantpal/core/widgets/photo_picker_sheet.dart';
import 'maintenance_colors.dart';

/// Daily journal photo upload. Owns its own picked-image state.
class MaintenanceJournalSection extends StatefulWidget {
  const MaintenanceJournalSection({super.key});

  @override
  State<MaintenanceJournalSection> createState() => _MaintenanceJournalSectionState();
}

class _MaintenanceJournalSectionState extends State<MaintenanceJournalSection> {
  Uint8List? _image;

  Future<void> _upload() async {
    final p = await pickPhoto(context);
    if (p != null) setState(() => _image = p);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle('Journal Entry'),
        if (_image != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.memory(_image!, height: 140, width: double.infinity, fit: BoxFit.cover),
            ),
          ),
        const Center(child: Icon(Icons.file_upload_outlined, color: kMaintenanceIconLight, size: 28)),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _upload,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.greenPrimary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 46),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(_image == null ? 'Upload images for daily journal entry' : 'Replace journal photo'),
        ),
      ],
    );
  }
}