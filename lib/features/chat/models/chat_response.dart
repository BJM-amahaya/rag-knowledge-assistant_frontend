class Source {
  final String documentName;
  final int page;
  Source({required this.documentName, required this.page});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      documentName: json['documentName'],
      page: json['page'],
    );
  }
}

class ChatResponse {
  final String message;
  final List<Source> sources;

  ChatResponse({required this.message, required this.sources});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      message: json['message'],
      sources: (json['sources'] as List)
          .map((s) => Source.fromJson(s))
          .toList(),
    );
  }
}
