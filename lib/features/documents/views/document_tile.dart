import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/models/document.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/providers/document_provider.dart';

class DocumentTile extends ConsumerWidget {
  final Document document;
  const DocumentTile({super.key, required this.document});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = document.size;
    final sizeText = size != null
        ? (size >= 1048576
            ? '${(size / 1048576).toStringAsFixed(1)}MB'
            : '${(size / 1024).toStringAsFixed(1)}KB')
        : null;

    return Dismissible(
      key: ValueKey(document.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        bool? result;
        await showShadDialog(
          context: context,
          builder: (context) => ShadDialog.alert(
            title: const Text('削除確認'),
            description: Text('「${document.name}」を削除しますか？'),
            actions: [
              ShadButton.outline(
                child: const Text('キャンセル'),
                onPressed: () {
                  result = false;
                  Navigator.of(context).pop();
                },
              ),
              ShadButton.destructive(
                child: const Text('削除'),
                onPressed: () {
                  result = true;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
        return result ?? false;
      },
      onDismissed: (_) async {
        await ref.read(documentNotifierProvider.notifier).deleteDocument(document.id);
        ref.invalidate(documentsProvider);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: theme.colorScheme.error,
        child: Icon(LucideIcons.trash2, color: theme.colorScheme.onError),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ShadCard(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                LucideIcons.fileText,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.name,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      document.uploadedAt.toIso8601String().substring(0, 10),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              if (sizeText != null)
                Text(
                  sizeText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
