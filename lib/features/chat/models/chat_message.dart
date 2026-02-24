import 'package:rag_knowledge_assistant_frontend/features/chat/models/chat_response.dart';

class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final List<Source> sources;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.sources = const [],
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      sources: json['sources'] != null
          ? (json['sources'] as List).map((s) => Source.fromJson(s)).toList()
          : [],
    );
  }
}
