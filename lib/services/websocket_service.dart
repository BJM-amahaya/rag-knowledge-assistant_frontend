import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:rag_knowledge_assistant_frontend/core/config/env_config.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/models/agent_progress.dart';

/// WebSocket サービスの抽象クラス
abstract class WebSocketService {
  Stream<AgentProgress> connect(String taskId, String taskDescription);
  void disconnect();
}

/// モック版: 擬似的に5つのAgentの進捗を1秒間隔で返す
class MockWebSocketService implements WebSocketService {
  @override
  Stream<AgentProgress> connect(
    String taskId,
    String taskDescription,
  ) async* {
    final mockResults = [
      {
        'analyzer': {
          'analysis': {
            'category': '開発',
            'purpose': taskDescription,
            'urgency': '中',
            'complexity': '中',
            'key_requirements': ['設計', '実装', 'テスト'],
            'constraints': ['期間: 1ヶ月'],
          },
        },
      },
      {
        'decomposer': {
          'subtasks': [
            {
              'id': 'subtask_1',
              'title': '要件整理',
              'description': '必要な要件を整理する',
              'dependencies': [],
            },
            {
              'id': 'subtask_2',
              'title': '設計',
              'description': '全体設計を行う',
              'dependencies': ['subtask_1'],
            },
            {
              'id': 'subtask_3',
              'title': '実装',
              'description': 'コードを書く',
              'dependencies': ['subtask_2'],
            },
          ],
        },
      },
      {
        'estimator': {
          'estimates': [
            {
              'subtask_id': 'subtask_1',
              'title': '要件整理',
              'estimated_minutes': 120,
            },
            {
              'subtask_id': 'subtask_2',
              'title': '設計',
              'estimated_minutes': 240,
            },
            {
              'subtask_id': 'subtask_3',
              'title': '実装',
              'estimated_minutes': 480,
            },
          ],
          'total_minutes': 840,
        },
      },
      {
        'prioritizer': {
          'priorities': [
            {
              'subtask_id': 'subtask_1',
              'title': '要件整理',
              'priority': '高',
              'quadrant': '重要かつ緊急',
            },
            {
              'subtask_id': 'subtask_2',
              'title': '設計',
              'priority': '高',
              'quadrant': '重要かつ緊急',
            },
            {
              'subtask_id': 'subtask_3',
              'title': '実装',
              'priority': '中',
              'quadrant': '重要だが緊急でない',
            },
          ],
        },
      },
      {
        'scheduler': {
          'schedule': [
            {
              'subtask_id': 'subtask_1',
              'scheduled_date': '2026-02-26',
              'scheduled_time': '09:00',
              'duration_minutes': 120,
            },
            {
              'subtask_id': 'subtask_2',
              'scheduled_date': '2026-02-27',
              'scheduled_time': '09:00',
              'duration_minutes': 240,
            },
            {
              'subtask_id': 'subtask_3',
              'scheduled_date': '2026-02-28',
              'scheduled_time': '09:00',
              'duration_minutes': 480,
            },
          ],
          'total_days': 3,
          'warnings': [],
        },
      },
    ];

    for (final result in mockResults) {
      await Future.delayed(const Duration(seconds: 1));
      yield AgentProgress(type: 'progress', data: result);
    }

    // 完了メッセージ
    await Future.delayed(const Duration(milliseconds: 500));
    yield AgentProgress(type: 'complete', data: {
      'id': taskId,
      'task': taskDescription,
      'status': 'completed',
    });
  }

  @override
  void disconnect() {}
}

/// 実API版: web_socket_channel を使用
class ApiWebSocketService implements WebSocketService {
  WebSocketChannel? _channel;

  @override
  Stream<AgentProgress> connect(
    String taskId,
    String taskDescription,
  ) async* {
    final uri = Uri.parse('${EnvConfig.wsBaseUrl}/ws/$taskId');
    _channel = WebSocketChannel.connect(uri);

    // start_task メッセージを送信
    _channel!.sink.add(jsonEncode({
      'action': 'start_task',
      'task': taskDescription,
    }));

    // サーバーからの受信を yield
    await for (final message in _channel!.stream) {
      final json = jsonDecode(message as String) as Map<String, dynamic>;
      yield AgentProgress.fromJson(json);
    }
  }

  @override
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}
