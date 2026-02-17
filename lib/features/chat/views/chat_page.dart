import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:rag_knowledge_assistant_frontend/features/chat/providers/chat_provider.dart';
import 'package:rag_knowledge_assistant_frontend/features/chat/views/chat_bubble.dart';
import 'package:rag_knowledge_assistant_frontend/features/chat/views/chat_input.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatNotifierProvider);
    final theme = Theme.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('RAG チャット')),
      body: Column(
        children: [
          Expanded(
            child: chatState.messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.messageCircle,
                          size: 64,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '質問してみましょう！',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'アップロードしたドキュメントについて\nAIに質問できます',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: chatState.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatState.messages[index];
                      return ChatBubble(message: message);
                    },
                  ),
          ),
          if (chatState.isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(width: 200, child: ShadProgress()),
            ),
          const ChatInput(),
        ],
      ),
    );
  }
}
