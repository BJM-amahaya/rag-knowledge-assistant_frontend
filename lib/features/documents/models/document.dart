class Document {
  final String id;
  final String name;
  final DateTime uploadedAt;
  final int? size;
  Document({
    required this.id,
    required this.name,
    required this.uploadedAt,
    this.size,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    final rawDate = json['uploadedAt'];
    return Document(
      id: json['id'],
      name: json['name'],
      uploadedAt: rawDate is DateTime ? rawDate : DateTime.parse(rawDate),
      size: json['size'],
    );
  }
}
