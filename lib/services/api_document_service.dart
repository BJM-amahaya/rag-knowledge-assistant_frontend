import 'package:dio/dio.dart';
import 'package:rag_knowledge_assistant_frontend/core/network/api_client.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/models/document.dart';
import 'package:rag_knowledge_assistant_frontend/services/document_service.dart';

class ApiDocumentService implements DocumentService {
  final ApiClient _apiClient;

  ApiDocumentService(this._apiClient);

  @override
  Future<List<Document>> getDocuments() async {
    final response = await _apiClient.get('/documents');
    final List<dynamic> data = response.data;
    return data.map((json) => Document.fromJson(json)).toList();
  }

  @override
  Future<Document> uploadDocument(String filePath, String fileName) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });
    final response = await _apiClient.post('/documents', formData);
    return Document.fromJson(response.data);
  }

  @override
  Future<void> deleteDocument(String id) async {
    await _apiClient.delete('/documents/$id');
  }
}
