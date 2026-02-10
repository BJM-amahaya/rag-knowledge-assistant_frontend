import 'package:rag_knowledge_assistant_frontend/features/documents/models/document.dart';

abstract class DocumentService {
  Future<List<Document>> getDocuments();
  Future<Document> uploadDocument(String filePath, String fileName);
  Future<void> deleteDocument(String id);
}
