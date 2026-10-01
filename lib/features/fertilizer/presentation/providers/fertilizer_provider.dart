import 'package:flutter/foundation.dart';
import '../../../../core/network/failure.dart';
import '../../domain/model/fertilizer.dart';
import '../../domain/repositories/fertilizer_repository.dart';

class FertilizerController extends ChangeNotifier {
  FertilizerController(this._repo);
  final FertilizerRepository _repo;

  FertilizerCatalog catalog = const FertilizerCatalog(items: [], safetyTips: []);
  String query = '';
  bool loading = true;
  String? error;

  List<Fertilizer> get filtered => catalog.items.where((f) => f.matches(query)).toList();

  Fertilizer? byId(String id) {
    for (final f in catalog.items) {
      if (f.id == id) return f;
    }
    return null;
  }

  Future<void> load() async {
    try {
      catalog = await _repo.getCatalog();
    } catch (e) {
      error = Failure.from(e).message;
    }
    loading = false;
    notifyListeners();
  }

  void setQuery(String q) {
    query = q;
    notifyListeners();
  }
}