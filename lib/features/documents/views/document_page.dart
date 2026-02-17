import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/providers/document_provider.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/views/document_tile.dart';

class DocumentPage extends ConsumerWidget {
  const DocumentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ref
        .watch(documentsProvider)
        .when(
          loading: () => const Center(
            child: SizedBox(width: 200, child: ShadProgress()),
          ),
          error: (err, stack) => Padding(
            padding: const EdgeInsets.all(16),
            child: ShadAlert.destructive(
              icon: const Icon(LucideIcons.triangleAlert),
              title: const Text('エラーが発生しました'),
              description: Text('$err'),
            ),
          ),
          data: (documents) {
            if (documents.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.fileText,
                      size: 64,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ドキュメントをアップロードしましょう',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '右下の + ボタンから\n追加できます',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return DocumentTile(document: documents[index]);
              },
            );
          },
        );
  }
}
