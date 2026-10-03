import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';

class PlantRemoteDataSource {
  PlantRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> fetchAll() async {
    final r = await _api.dio.get('/api/v1/plants');
    return (r.data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> create(
    Map<String, dynamic> body,
  ) async =>
      (await _api.dio.post('/api/v1/plants', data: body)).data
          as Map<String, dynamic>;

  Future<Map<String, dynamic>> patch(
    String id,
    Map<String, dynamic> body,
  ) async =>
      (await _api.dio.patch('/api/v1/plants/$id', data: body)).data
          as Map<String, dynamic>;

  Future<void> remove(String id) async {
    await _api.dio.delete('/api/v1/plants/$id');
  }

  /// POST /api/v1/plants/{id}/water  (no body)
  Future<Map<String, dynamic>> water(String id) async =>
      (await _api.dio.post('/api/v1/plants/$id/water')).data
          as Map<String, dynamic>;

  /// POST /api/v1/plants/{id}/fertilize  (no body)
  /// The backend rejects this with 400 if the roadmap has no fertilizing
  /// interval yet (e.g. seedlings).
  Future<Map<String, dynamic>> fertilize(String id) async =>
      (await _api.dio.post('/api/v1/plants/$id/fertilize')).data
          as Map<String, dynamic>;

  // NOTE: the backend has no /plants/{id}/image route yet, so this call
  // will 404 until that endpoint is added.
  Future<Map<String, dynamic>> uploadImage(
    String id,
    Uint8List imageBytes,
  ) async {
    final form = FormData.fromMap({
      'image': MultipartFile.fromBytes(
        imageBytes,
        filename: 'plant.jpg',
      ),
    });

    return (await _api.dio.post(
      '/api/v1/plants/$id/image',
      data: form,
    ))
        .data as Map<String, dynamic>;
  }

  /// POST /api/v1/plants/identify
  Future<Map<String, dynamic>> identify(Uint8List imageBytes) async {
    final form = FormData.fromMap({
      'image': MultipartFile.fromBytes(
        imageBytes,
        filename: 'plant_identify.jpg',
      ),
    });

    return (await _api.dio.post(
      '/api/v1/plants/identify',
      data: form,
    ))
        .data as Map<String, dynamic>;
  }
}
