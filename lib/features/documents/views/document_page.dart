import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/providers/document_provider.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/views/document_tile.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/views/upload_dialog.dart';

class DocumentPage extends ConsumerWidget {
  const DocumentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('ドキュメント')),
      body: ref
          .watch(documentsProvider)
          .when(
            loading: () => CircularProgressIndicator(),
            error: (err, stack) => Text('アップロードに失敗しました。'),
            data: (documents) => ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return DocumentTile(document: documents[index]);
              },
            ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => UploadDialog());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
