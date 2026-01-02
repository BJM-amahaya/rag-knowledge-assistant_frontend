class Document {
  final String id;
  final String name;
  final DateTime uploadedAt;
  final int size;
  Document({
    required this.id,
    required this.name,
    required this.uploadedAt,
    required this.size,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      name: json['name'],
      uploadedAt: json['uploadedAt'],
      size: json['size'],
    );
  }
}
