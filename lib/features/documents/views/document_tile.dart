import 'package:flutter/material.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/models/document.dart';

class DocumentTile extends StatelessWidget {
  final Document document;
  const DocumentTile({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final size = document.size;
    final sizeText = size != null
        ? (size >= 1048576
            ? '${(size / 1048576).toStringAsFixed(1)}MB'
            : '${(size / 1024).toStringAsFixed(1)}KB')
        : null;

    return Card(
      color: Colors.blue.shade300, //後で調整
      margin: EdgeInsets.all(4), //後で調整
      child: Padding(
        padding: EdgeInsets.all(4), //後で調整
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.text_snippet_outlined, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min, //後で調整
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(document.name, style: TextStyle(fontSize: 14)),
                  Text(
                    document.uploadedAt.toIso8601String().substring(0, 10),
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            if (sizeText != null) Text(sizeText),
          ],
        ),
      ),
    );
  }
}
