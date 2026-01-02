import 'package:rag_knowledge_assistant_frontend/features/documents/models/document.dart';

class DocumentState {
  final List<Document> documents;
  final bool isLoading;
  final String? errorMessage;

  const DocumentState({
    required this.documents,
    required this.isLoading,
    this.errorMessage,
  });

  factory DocumentState.initial() {
    return const DocumentState(
      documents: [],
      isLoading: false,
      errorMessage: null,
    );
  }

  DocumentState copyWith({
    List<Document>? documents,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DocumentState(
      documents: documents ?? this.documents,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
