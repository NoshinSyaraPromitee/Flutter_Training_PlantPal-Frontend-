import 'package:dio/dio.dart';
import 'package:plantpal/core/network/api_client.dart';

class PlantRemoteDataSource {
  PlantRemoteDataSource(this._api);
  final ApiClient _api;

  Future<List<Map<String, dynamic>>> fetchAll() async {
    final r = await _api.dio.get('/api/v1/plants');
    return ((r.data as Map<String, dynamic>)['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> body) async =>
      ((await _api.dio.post('/api/v1/plants', data: body)).data as Map<String, dynamic>)['data'] as Map<String, dynamic>;

  // TODO(backend): no PATCH /plants/{id} endpoint exists yet — the backend
  // Plant model doesn't even have lastWatered/waterLevel fields (see
  // internal/domain/plant/plant.go). markWatered() will 404 until that's
  // built out; tracked separately from the points-earning wiring.
  Future<Map<String, dynamic>> patch(String id, Map<String, dynamic> body) async =>
      ((await _api.dio.patch('/api/v1/plants/$id', data: body)).data as Map<String, dynamic>)['data']
          as Map<String, dynamic>;

  Future<void> remove(String id) async {
    await _api.dio.delete('/api/v1/plants/$id');
  }

  // TODO(backend): no image-upload endpoint exists yet either.
  Future<Map<String, dynamic>> uploadImage(String id, String path) async {
    final form = FormData.fromMap({'image': await MultipartFile.fromFile(path)});
    return ((await _api.dio.post('/api/v1/plants/$id/image', data: form)).data as Map<String, dynamic>)['data']
        as Map<String, dynamic>;
  }
}