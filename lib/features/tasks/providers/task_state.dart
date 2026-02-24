import 'package:rag_knowledge_assistant_frontend/features/tasks/models/task.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/models/agent_progress.dart';

class TaskState {
  // 一覧用
  final List<Task> tasks;
  final bool isLoading;
  final String? errorMessage;

  // ストリーミング用
  final List<AgentProgress> progressSteps;
  final bool isProcessing;
  final String? currentStep;

  const TaskState({
    required this.tasks,
    required this.isLoading,
    this.errorMessage,
    required this.progressSteps,
    required this.isProcessing,
    this.currentStep,
  });

  factory TaskState.initial() {
    return const TaskState(
      tasks: [],
      isLoading: false,
      errorMessage: null,
      progressSteps: [],
      isProcessing: false,
      currentStep: null,
    );
  }

  TaskState copyWith({
    List<Task>? tasks,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    List<AgentProgress>? progressSteps,
    bool? isProcessing,
    String? currentStep,
    bool clearCurrentStep = false,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      progressSteps: progressSteps ?? this.progressSteps,
      isProcessing: isProcessing ?? this.isProcessing,
      currentStep: clearCurrentStep ? null : (currentStep ?? this.currentStep),
    );
  }
}
