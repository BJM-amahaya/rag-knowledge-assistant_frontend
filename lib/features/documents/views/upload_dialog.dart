import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/models/document.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/providers/document_provider.dart';

class UploadDialog extends ConsumerStatefulWidget {
  const UploadDialog({super.key});

  @override
  ConsumerState<UploadDialog> createState() => _UploadDialogState();
}

class _UploadDialogState extends ConsumerState<UploadDialog> {
  final _nameController = TextEditingController();
  bool _isUploading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ドキュメントアップロード'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'サンプルファイル',
              hintText: 'サンプル.pdf',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('キャンセル'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text;
            if (name.isEmpty) return;
            final document = Document(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: name,
              uploadedAt: DateTime.now(),
              size: 0,
            );
            ref.read(documentNotifierProvider.notifier).addDocument(document);
            Navigator.of(context).pop(true);
          },
          child: Text('アップロード'),
        ),
      ],
    );
  }
}
