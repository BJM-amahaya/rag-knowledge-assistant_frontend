import 'package:dio/dio.dart';
import 'package:rag_knowledge_assistant_frontend/core/config/env_config.dart';

class ApiClient {
  final Dio _dio;
  ApiClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: EnvConfig.apiBaseUrl,
          connectTimeout: Duration(seconds: 5),
        ),
      );
  Future<Response> get(String path) async {
    return await _dio.get(path);
  }

  Future<Response> post(String path, dynamic data) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}
