import 'package:rag_knowledge_assistant_frontend/features/documents/models/document.dart';

class DocumentState {
  final List<Document> documents;
  final bool isLoading;
  final bool isUploading;
  final String? errorMessage;

  const DocumentState({
    required this.documents,
    required this.isLoading,
    this.isUploading = false,
    this.errorMessage,
  });

  factory DocumentState.initial() {
    return const DocumentState(
      documents: [],
      isLoading: false,
      isUploading: false,
      errorMessage: null,
    );
  }

  DocumentState copyWith({
    List<Document>? documents,
    bool? isLoading,
    bool? isUploading,
    String? errorMessage,
  }) {
    return DocumentState(
      documents: documents ?? this.documents,
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
