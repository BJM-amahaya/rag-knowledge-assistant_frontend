class AgentProgress {
  final String type; // "progress" or "complete"
  final Map<String, dynamic> data;

  AgentProgress({required this.type, required this.data});

  factory AgentProgress.fromJson(Map<String, dynamic> json) {
    return AgentProgress(
      type: json['type'] ?? '',
      data: json['data'] ?? {},
    );
  }

  /// WebSocketの進捗データからAgent名を取得
  String? get agentName {
    if (data.isEmpty) return null;
    return data.keys.first;
  }

  /// Agent名の日本語ラベル
  static const Map<String, String> agentLabels = {
    'analyzer': 'タスク分析',
    'decomposer': 'タスク分解',
    'estimator': '時間見積もり',
    'prioritizer': '優先度決定',
    'scheduler': 'スケジュール作成',
  };

  /// Agent名の順番リスト
  static const List<String> agentOrder = [
    'analyzer',
    'decomposer',
    'estimator',
    'prioritizer',
    'scheduler',
  ];
}
