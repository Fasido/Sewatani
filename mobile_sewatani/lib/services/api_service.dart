import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = AppConfig.baseUrl});

  Future<Map<String, dynamic>> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl/$endpoint');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 15));
      return _handleResponse(response, uri.toString());
    } catch (e) {
      throw ApiException('Gagal terhubung ke server: $e');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$baseUrl/$endpoint');

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response, uri.toString());
    } catch (e) {
      throw ApiException('Gagal terhubung ke server: $e');
    }
  }

  Future<Map<String, dynamic>> uploadImage(
    String endpoint,
    File imageFile, {
    String fieldName = 'image',
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');

    try {
      final request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath(fieldName, imageFile.path),
      );

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));

      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response, uri.toString());
    } catch (e) {
      throw ApiException('Upload gambar gagal: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response, String url) {
    dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      final preview = response.body.length > 120
          ? response.body.substring(0, 120)
          : response.body;

      throw ApiException(
        'Response API bukan JSON. Cek endpoint: $url. Isi awal response: $preview',
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw ApiException('Format response API tidak valid dari $url');
    }

    final success = decoded['success'] == true;

    if (!success) {
      throw ApiException(
        decoded['message']?.toString() ?? 'Request API gagal dari $url',
      );
    }

    return decoded;
  }
}
