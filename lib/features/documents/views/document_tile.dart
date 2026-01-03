import 'package:flutter/material.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/models/document.dart';

class DocumentTile extends StatelessWidget {
  final Document document;
  const DocumentTile({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final sizeText = document.size >= 1048576
        ? '${(document.size / 1048576).toStringAsFixed(1)}MB'
        : '${(document.size / 1024).toStringAsFixed(1)}KB';

    return Card(
      color: Colors.blue, //後で調整
      margin: EdgeInsets.all(20), //後で調整
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12), //後で調整
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.text_snippet_outlined),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(document.name),
                  Text(document.uploadedAt.toIso8601String().substring(0, 10)),
                ],
              ),
            ),
            Text(sizeText),
          ],
        ),
      ),
    );
  }
}
