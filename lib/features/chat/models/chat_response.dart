class Source {
  final String documentName;
  final int page;
  Source({required this.documentName, required this.page});
}

class ChatResponse {
  final String message;
  final List<Source> sources;

  ChatResponse({required this.message, required this.sources});
}
