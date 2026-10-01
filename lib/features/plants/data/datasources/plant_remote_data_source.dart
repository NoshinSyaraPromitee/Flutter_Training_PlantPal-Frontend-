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
}