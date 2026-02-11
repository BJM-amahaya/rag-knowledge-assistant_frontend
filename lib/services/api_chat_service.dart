import 'package:rag_knowledge_assistant_frontend/core/network/api_client.dart';
import 'package:rag_knowledge_assistant_frontend/features/chat/models/chat_response.dart';
import 'package:rag_knowledge_assistant_frontend/services/chat_service.dart';

class ApiChatService implements ChatService {
  final ApiClient _apiClient;

  ApiChatService(this._apiClient);

  @override
  Future<ChatResponse> sendMessage(String message) async {
    final response = await _apiClient.post('/chat', {'message': message});
    return ChatResponse.fromJson(response.data);
  }
}
