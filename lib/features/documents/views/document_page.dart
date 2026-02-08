import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/providers/document_provider.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/views/document_tile.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/views/upload_dialog.dart';

class DocumentPage extends ConsumerWidget {
  const DocumentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('ドキュメント')),
      body: ref
          .watch(documentsProvider)
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text(
                'エラーが発生しました: $err',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
            data: (documents) {
              if (documents.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.description_outlined,
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
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => UploadDialog());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
