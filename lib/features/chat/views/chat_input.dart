import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:rag_knowledge_assistant_frontend/features/chat/providers/chat_provider.dart';

class ChatInput extends ConsumerStatefulWidget {
  const ChatInput({super.key});

  @override
  ConsumerState<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends ConsumerState<ChatInput> {
  final _controller = TextEditingController();
  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    ref.read(chatNotifierProvider.notifier).sendMessage(text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: ShadInput(
              controller: _controller,
              onSubmitted: (_) => _sendMessage(),
              placeholder: const Text('メッセージを入力....'),
            ),
          ),
          const SizedBox(width: 8),
          ShadButton.outline(
            width: 40,
            height: 40,
            padding: EdgeInsets.zero,
            leading: const Icon(LucideIcons.send, size: 18),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
