import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_knowledge_assistant_frontend/services/mock_chat_service.dart';
import 'package:rag_knowledge_assistant_frontend/features/chat/models/chat_message.dart';
import 'package:rag_knowledge_assistant_frontend/features/chat/providers/chat_state.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  final MockChatService _service;
  ChatNotifier(this._service) : super(ChatState.initial());
  Future<void> sendMessage(String content) async {
    final userMessage = ChatMessage(
      id: DateTime.now().toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(messages: [...state.messages, userMessage]);
    state = state.copyWith(isLoading: true);
    final response = await _service.sendMessage(content);

    final aiMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: response.message,
      isUser: false,
      timestamp: DateTime.now(),
      sources: response.sources,
    );
    state = state.copyWith(
      messages: [...state.messages, aiMessage],
      isLoading: false,
    );
  }
}

final chatNotifierProvider = StateNotifierProvider<ChatNotifier, ChatState>((
  ref,
) {
  return ChatNotifier(MockChatService());
});
