import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_knowledge_assistant_frontend/features/chat/models/chat_message.dart';
import 'package:rag_knowledge_assistant_frontend/features/chat/providers/chat_state.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState.initial());
  Future<void> sendMessage(String content) async {}
}
