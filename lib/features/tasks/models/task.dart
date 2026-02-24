class Task {
  final String id;
  final String task;
  final String status;
  final Map<String, dynamic>? analysis;
  final List<dynamic>? subtasks;
  final List<dynamic>? estimates;
  final int? totalMinutes;
  final List<dynamic>? priorities;
  final List<dynamic>? schedule;
  final int? totalDays;
  final List<dynamic>? warnings;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.task,
    required this.status,
    this.analysis,
    this.subtasks,
    this.estimates,
    this.totalMinutes,
    this.priorities,
    this.schedule,
    this.totalDays,
    this.warnings,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    final rawDate = json['created_at'];
    return Task(
      id: json['id'],
      task: json['task'],
      status: json['status'] ?? 'unknown',
      analysis: json['analysis'],
      subtasks: json['subtasks'],
      estimates: json['estimates'],
      totalMinutes: json['total_minutes'],
      priorities: json['priorities'],
      schedule: json['schedule'],
      totalDays: json['total_days'],
      warnings: json['warnings'] != null
          ? List<dynamic>.from(json['warnings'])
          : null,
      createdAt: rawDate is DateTime ? rawDate : DateTime.parse(rawDate),
    );
  }
}
