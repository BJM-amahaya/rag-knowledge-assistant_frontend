import 'package:rag_knowledge_assistant_frontend/features/chat/models/chat_response.dart';
import 'package:rag_knowledge_assistant_frontend/services/chat_service.dart';

class MockChatService implements ChatService {
  @override
  Future<ChatResponse> sendMessage(String message) async {
    await Future.delayed(Duration(seconds: 1)); // AIが考えてる風

    return ChatResponse(
      message: 'モックの応答です。「$message」について回答しています。',
      sources: [
        Source(documentName: 'プロジェクト計画書.pdf', page: 3),
        Source(documentName: '技術仕様書.docx', page: 12),
      ],
    );
  }
}
