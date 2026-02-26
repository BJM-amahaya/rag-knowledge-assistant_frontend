import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/providers/document_provider.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/views/upload_dialog.dart';

class QuickActionChips extends ConsumerWidget {
  const QuickActionChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Wrap(
        spacing: 8,
        children: [
          ShadButton.outline(
            size: ShadButtonSize.sm,
            leading: const Icon(LucideIcons.upload, size: 16),
            onPressed: () async {
              final result = await showShadDialog<bool>(
                context: context,
                builder: (context) => const UploadDialog(),
              );
              if (result == true) {
                ref.invalidate(documentsProvider);
              }
            },
            child: const Text('アップロード'),
          ),
          ShadButton.outline(
            size: ShadButtonSize.sm,
            leading: const Icon(LucideIcons.listChecks, size: 16),
            onPressed: () => context.go('/tasks/create'),
            child: const Text('タスク作成'),
          ),
        ],
      ),
    );
  }
}
