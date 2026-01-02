import 'package:rag_knowledge_assistant_frontend/features/documents/models/document.dart';

class MockDocumentService {
  // ダミーのドキュメントリスト
  final List<Map<String, dynamic>> _mockDocuments = [
    {
      'id': '1',
      'name': 'プロジェクト計画書.pdf',
      'uploadedAt': DateTime.now(),
      'size': 1024000, // 1MB
    },
    {
      'id': '2',
      'name': '技術仕様書.docx',
      'uploadedAt': DateTime.now(),
      'size': 512000,
    },
  ];

  // ドキュメント一覧を取得（偽データを返す）
  Future<List<Document>> getDocuments() async {
    await Future.delayed(Duration(milliseconds: 500)); // ← 通信してる風に遅延
    return _mockDocuments.map((d) => Document.fromJson(d)).toList();
  }

  // アップロード（成功したフリをする）
  Future<Document> uploadDocument(String name) async {
    await Future.delayed(Duration(seconds: 1));
    // 新しいドキュメントを追加して返す
    final newDocument = Document(
      id: '3',
      name: name,
      uploadedAt: DateTime.now(),
      size: 100000,
    );
    return newDocument;
  }
}
