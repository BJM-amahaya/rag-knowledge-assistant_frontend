import 'package:rag_knowledge_assistant_frontend/features/chat/models/chat_response.dart';

abstract class ChatService {
  Future<ChatResponse> sendMessage(String message);
}
