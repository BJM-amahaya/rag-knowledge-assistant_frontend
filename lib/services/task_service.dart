import 'package:rag_knowledge_assistant_frontend/features/tasks/models/task.dart';

abstract class TaskService {
  Future<List<Task>> getTasks();
  Future<Task> createTask(String taskDescription);
  Future<Task> getTask(String id);
  Future<void> deleteTask(String id);
}
