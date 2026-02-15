import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_knowledge_assistant_frontend/core/config/env_config.dart';
import 'package:rag_knowledge_assistant_frontend/core/network/api_client.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/models/task.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/providers/task_state.dart';
import 'package:rag_knowledge_assistant_frontend/services/api_task_service.dart';
import 'package:rag_knowledge_assistant_frontend/services/mock_task_service.dart';
import 'package:rag_knowledge_assistant_frontend/services/task_service.dart';
import 'package:rag_knowledge_assistant_frontend/services/websocket_service.dart';

// TaskService の Provider（useMock で切り替え）
final taskServiceProvider = Provider<TaskService>((ref) {
  if (EnvConfig.useMock) {
    return MockTaskService();
  } else {
    return ApiTaskService(ApiClient());
  }
});

// WebSocketService の Provider（useMock で切り替え）
final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  if (EnvConfig.useMock) {
    return MockWebSocketService();
  } else {
    return ApiWebSocketService();
  }
});

// タスク一覧の FutureProvider
final tasksProvider = FutureProvider<List<Task>>((ref) async {
  final service = ref.watch(taskServiceProvider);
  return await service.getTasks();
});

// TaskNotifier（状態管理）
class TaskNotifier extends StateNotifier<TaskState> {
  final TaskService _service;
  final WebSocketService _wsService;

  TaskNotifier(this._service, this._wsService) : super(TaskState.initial());

  /// タスク一覧を取得
  Future<void> fetchTasks() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final tasks = await _service.getTasks();
      state = state.copyWith(tasks: tasks, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// WebSocket ストリーミング開始
  Future<void> startStreaming(String taskId, String taskDescription) async {
    state = state.copyWith(
      isProcessing: true,
      progressSteps: [],
      clearCurrentStep: true,
    );

    try {
      await for (final progress
          in _wsService.connect(taskId, taskDescription)) {
        if (progress.type == 'progress') {
          final steps = [...state.progressSteps, progress];
          state = state.copyWith(
            progressSteps: steps,
            currentStep: progress.agentName,
          );
        } else if (progress.type == 'complete') {
          state = state.copyWith(
            isProcessing: false,
            clearCurrentStep: true,
          );
        }
      }
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// タスクを削除
  Future<void> deleteTask(String id) async {
    try {
      await _service.deleteTask(id);
      final updatedList = state.tasks.where((t) => t.id != id).toList();
      state = state.copyWith(tasks: updatedList);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// ストリーミング進捗をリセット
  void resetProgress() {
    state = state.copyWith(
      progressSteps: [],
      isProcessing: false,
      clearCurrentStep: true,
    );
  }

  @override
  void dispose() {
    _wsService.disconnect();
    super.dispose();
  }
}

// TaskNotifier の Provider
final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  return TaskNotifier(
    ref.watch(taskServiceProvider),
    ref.watch(webSocketServiceProvider),
  );
});
