import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/models/document.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/providers/document_provider.dart';

class UploadDialog extends ConsumerStatefulWidget {
  const UploadDialog({super.key});

  @override
  ConsumerState<UploadDialog> createState() => _UploadDialogState();
}

class _UploadDialogState extends ConsumerState<UploadDialog> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: const Text('ドキュメントアップロード'),
      description: const Text('アップロードするファイル名を入力してください'),
      actions: [
        ShadButton.outline(
          child: const Text('キャンセル'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        ShadButton(
          leading: const Icon(LucideIcons.upload),
          child: const Text('アップロード'),
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
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ShadInput(
          controller: _nameController,
          placeholder: const Text('サンプル.pdf'),
        ),
      ),
    );
  }
}
