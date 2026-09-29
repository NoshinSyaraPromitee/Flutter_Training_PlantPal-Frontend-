import 'package:flutter/foundation.dart';
import '../../../../core/network/failure.dart';
import '../../domain/entities/chat_models.dart';
import '../../domain/repositories/ai_doctor_repository.dart';

class ScanController extends ChangeNotifier {
  ScanController(this._repo);
  final AiDoctorRepository _repo;

  bool loading = false;
  String? error;
  Uint8List? imageBytes;
  BotReply? result;

  /// [plantId] links the saved diagnosis to one of the user's plants.
  Future<bool> analyze(Uint8List bytes, {String? plantId}) async {
    loading = true;
    error = null;
    imageBytes = bytes;
    notifyListeners();
    try {
      result = await _repo.analyzeImage(bytes, plantId: plantId);
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      final f = Failure.from(e);
      error = f.statusCode == 429
          ? 'Rate limit reached. Please wait 10 seconds and try again.'
          : f.isUnauthorized
          ? 'Please sign in with Google to scan plants.'
          : "I couldn't analyze that photo. Please try again.";
      result = null;
      loading = false;
      notifyListeners();
      return false;
    }
  }
}
