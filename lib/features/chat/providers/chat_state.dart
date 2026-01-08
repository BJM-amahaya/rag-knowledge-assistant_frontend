import 'package:rag_knowledge_assistant_frontend/features/chat/models/chat_message.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? errorMessage;

  const ChatState({
    required this.messages,
    required this.isLoading,
    this.errorMessage,
  });

  factory ChatState.initial() {
    return const ChatState(messages: [], isLoading: false, errorMessage: null);
  }
  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
