import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/models/document.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/providers/document_state.dart';
import 'package:rag_knowledge_assistant_frontend/services/mock_document_service.dart';

final documentsProvider = FutureProvider<List<Document>>((ref) async {
  final service = MockDocumentService();
  final documents = await service.getDocuments();
  return documents;
});

class DocumentNotifier extends StateNotifier<DocumentState> {
  final MockDocumentService _service;

  DocumentNotifier(this._service) : super(DocumentState.initial());

  Future<void> fetchDocuments() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final documents = await _service.getDocuments();
      state = state.copyWith(documents: documents, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addDocument(Document document) async {
    final updatedList = [...state.documents, document];
    state = state.copyWith(documents: updatedList);
  }

  Future<void> deleteDocument(String id) async {
    final updatedList = state.documents.where((doc) => doc.id != id).toList();
    state = state.copyWith(documents: updatedList);
  }
}

final documentNotifierProvider =
    StateNotifierProvider<DocumentNotifier, DocumentState>((ref) {
      return DocumentNotifier(MockDocumentService());
    });
