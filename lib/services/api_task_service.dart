import 'package:rag_knowledge_assistant_frontend/core/network/api_client.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/models/task.dart';
import 'package:rag_knowledge_assistant_frontend/services/task_service.dart';

class ApiTaskService implements TaskService {
  final ApiClient _apiClient;

  ApiTaskService(this._apiClient);

  @override
  Future<List<Task>> getTasks() async {
    final response = await _apiClient.get('/tasks');
    final List<dynamic> data = response.data;
    return data.map((json) => Task.fromJson(json)).toList();
  }

  @override
  Future<Task> createTask(String taskDescription) async {
    final response = await _apiClient.post('/tasks', {'task': taskDescription});
    return Task.fromJson(response.data);
  }

  @override
  Future<Task> getTask(String id) async {
    final response = await _apiClient.get('/tasks/$id');
    return Task.fromJson(response.data);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _apiClient.delete('/tasks/$id');
  }
}
