import 'dart:typed_data';

import 'package:rag_knowledge_assistant_frontend/features/documents/models/document.dart';
import 'package:rag_knowledge_assistant_frontend/services/document_service.dart';

class MockDocumentService implements DocumentService {
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
  @override
  Future<List<Document>> getDocuments() async {
    await Future.delayed(Duration(milliseconds: 500)); // ← 通信してる風に遅延
    return _mockDocuments.map((d) => Document.fromJson(d)).toList();
  }

  // アップロード（成功したフリをする）
  @override
  Future<Document> uploadDocument(Uint8List fileBytes, String fileName) async {
    await Future.delayed(Duration(seconds: 1));
    // 新しいドキュメントを追加して返す
    final newDocument = Document(
      id: '${_mockDocuments.length + 1}',
      name: fileName,
      uploadedAt: DateTime.now(),
      size: 100000,
    );
    _mockDocuments.add({
      'id': newDocument.id,
      'name': newDocument.name,
      'uploadedAt': newDocument.uploadedAt,
      'size': newDocument.size,
    });
    return newDocument;
  }

  // 削除（モック版はリストから除外するだけ）
  @override
  Future<void> deleteDocument(String id) async {
    await Future.delayed(Duration(milliseconds: 300));
    _mockDocuments.removeWhere((d) => d['id'] == id);
  }
}
