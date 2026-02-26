import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/providers/document_provider.dart';

class UploadDialog extends ConsumerStatefulWidget {
  const UploadDialog({super.key});

  @override
  ConsumerState<UploadDialog> createState() => _UploadDialogState();
}

class _UploadDialogState extends ConsumerState<UploadDialog> {
  PlatformFile? _selectedFile;
  bool _isUploading = false;
  String? _errorMessage;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
        _errorMessage = null;
      });
    }
  }

  Future<void> _upload() async {
    if (_selectedFile == null) {
      setState(() {
        _errorMessage = 'ファイルを選択してください';
      });
      return;
    }

    final fileBytes = _selectedFile!.bytes;
    if (fileBytes == null) {
      setState(() {
        _errorMessage = 'ファイルデータを取得できませんでした';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(documentNotifierProvider.notifier)
          .uploadDocument(fileBytes, _selectedFile!.name);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _errorMessage = 'アップロードに失敗しました: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ShadDialog(
      title: const Text('ドキュメントアップロード'),
      description: const Text('PDFファイルを選択してアップロードしてください'),
      actions: [
        ShadButton.outline(
          onPressed: _isUploading ? null : () => Navigator.of(context).pop(false),
          child: const Text('キャンセル'),
        ),
        ShadButton(
          leading: _isUploading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(LucideIcons.upload),
          onPressed: _isUploading ? null : _upload,
          child: Text(_isUploading ? 'アップロード中...' : 'アップロード'),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ShadButton.outline(
              leading: const Icon(LucideIcons.file),
              onPressed: _isUploading ? null : _pickFile,
              child: Text(
                _selectedFile != null
                    ? _selectedFile!.name
                    : 'PDFファイルを選択...',
              ),
            ),
            if (_selectedFile != null) ...[
              const SizedBox(height: 8),
              Text(
                'サイズ: ${(_selectedFile!.size / 1024).toStringAsFixed(1)} KB',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              ShadAlert.destructive(
                icon: const Icon(LucideIcons.triangleAlert),
                title: Text(_errorMessage!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
