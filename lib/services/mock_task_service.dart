import 'package:rag_knowledge_assistant_frontend/features/tasks/models/task.dart';
import 'package:rag_knowledge_assistant_frontend/services/task_service.dart';

class MockTaskService implements TaskService {
  final List<Task> _mockTasks = [
    Task(
      id: '1',
      task: 'ECサイトの開発',
      status: 'completed',
      analysis: {
        'category': '開発',
        'purpose': 'オンラインショップの構築',
        'urgency': '高',
        'complexity': '高',
        'key_requirements': ['データベース設計', '決済機能', 'UI/UX設計'],
        'constraints': ['予算: 50万円', '期間: 3ヶ月'],
      },
      subtasks: [
        {'id': 'subtask_1', 'title': '要件定義', 'description': '必要な機能を洗い出す', 'dependencies': []},
        {'id': 'subtask_2', 'title': 'UI設計', 'description': '画面レイアウトを設計する', 'dependencies': ['subtask_1']},
        {'id': 'subtask_3', 'title': 'バックエンド開発', 'description': 'APIを実装する', 'dependencies': ['subtask_1']},
      ],
      estimates: [
        {'subtask_id': 'subtask_1', 'title': '要件定義', 'estimated_minutes': 480},
        {'subtask_id': 'subtask_2', 'title': 'UI設計', 'estimated_minutes': 960},
        {'subtask_id': 'subtask_3', 'title': 'バックエンド開発', 'estimated_minutes': 1920},
      ],
      totalMinutes: 3360,
      priorities: [
        {'subtask_id': 'subtask_1', 'title': '要件定義', 'priority': '高', 'quadrant': '重要かつ緊急'},
        {'subtask_id': 'subtask_3', 'title': 'バックエンド開発', 'priority': '高', 'quadrant': '重要かつ緊急'},
        {'subtask_id': 'subtask_2', 'title': 'UI設計', 'priority': '中', 'quadrant': '重要だが緊急でない'},
      ],
      schedule: [
        {'subtask_id': 'subtask_1', 'scheduled_date': '2026-02-26', 'scheduled_time': '09:00', 'duration_minutes': 480},
        {'subtask_id': 'subtask_2', 'scheduled_date': '2026-02-27', 'scheduled_time': '09:00', 'duration_minutes': 240},
        {'subtask_id': 'subtask_3', 'scheduled_date': '2026-02-27', 'scheduled_time': '13:00', 'duration_minutes': 240},
        {'subtask_id': 'subtask_3', 'scheduled_date': '2026-02-28', 'scheduled_time': '09:00', 'duration_minutes': 480},
      ],
      totalDays: 3,
      warnings: ['決済機能の実装には外部APIの契約が必要です'],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Task(
      id: '2',
      task: 'モバイルアプリのテスト計画',
      status: 'completed',
      analysis: {
        'category': 'テスト',
        'purpose': 'アプリの品質確保',
        'urgency': '中',
        'complexity': '中',
      },
      subtasks: [
        {'id': 'subtask_1', 'title': 'テストケース作成', 'description': 'テスト項目を洗い出す', 'dependencies': []},
        {'id': 'subtask_2', 'title': '自動テスト実装', 'description': 'テストコードを書く', 'dependencies': ['subtask_1']},
      ],
      estimates: [
        {'subtask_id': 'subtask_1', 'title': 'テストケース作成', 'estimated_minutes': 240},
        {'subtask_id': 'subtask_2', 'title': '自動テスト実装', 'estimated_minutes': 480},
      ],
      totalMinutes: 720,
      priorities: [
        {'subtask_id': 'subtask_1', 'title': 'テストケース作成', 'priority': '高', 'quadrant': '重要かつ緊急'},
        {'subtask_id': 'subtask_2', 'title': '自動テスト実装', 'priority': '中', 'quadrant': '重要だが緊急でない'},
      ],
      schedule: [
        {'subtask_id': 'subtask_1', 'scheduled_date': '2026-02-26', 'scheduled_time': '09:00', 'duration_minutes': 240},
        {'subtask_id': 'subtask_2', 'scheduled_date': '2026-02-27', 'scheduled_time': '09:00', 'duration_minutes': 480},
      ],
      totalDays: 2,
      warnings: [],
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  @override
  Future<List<Task>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockTasks);
  }

  @override
  Future<Task> createTask(String taskDescription) async {
    await Future.delayed(const Duration(seconds: 1));
    final newTask = Task(
      id: '${_mockTasks.length + 1}',
      task: taskDescription,
      status: 'completed',
      createdAt: DateTime.now(),
    );
    _mockTasks.add(newTask);
    return newTask;
  }

  @override
  Future<Task> getTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockTasks.firstWhere((t) => t.id == id);
  }

  @override
  Future<void> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockTasks.removeWhere((t) => t.id == id);
  }
}
