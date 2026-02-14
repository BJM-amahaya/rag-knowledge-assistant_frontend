import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/providers/task_provider.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/models/task.dart';

class TaskDetailPage extends ConsumerWidget {
  final String taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final taskState = ref.watch(taskNotifierProvider);

    // タスク一覧から該当タスクを検索
    final task = taskState.tasks.cast<Task?>().firstWhere(
          (t) => t?.id == taskId,
          orElse: () => null,
        );

    if (task == null) {
      // 一覧に無い場合はAPIから再取得を試みる
      return Scaffold(
        appBar: AppBar(title: const Text('タスク詳細')),
        body: FutureBuilder<Task>(
          future: ref.read(taskServiceProvider).getTask(taskId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'タスクが見つかりません',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              );
            }
            return _buildDetail(context, theme, snapshot.data!);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('タスク詳細')),
      body: _buildDetail(context, theme, task),
    );
  }

  Widget _buildDetail(BuildContext context, ThemeData theme, Task task) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // タスク名
          Text(task.task, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Chip(
            label: Text(task.status),
            backgroundColor: task.status == 'completed'
                ? Colors.green.shade100
                : theme.colorScheme.primaryContainer,
          ),
          if (task.totalMinutes != null || task.totalDays != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                if (task.totalMinutes != null) ...[
                  Icon(Icons.timer, size: 16, color: theme.colorScheme.outline),
                  const SizedBox(width: 4),
                  Text('合計 ${_formatMinutes(task.totalMinutes!)}'),
                  const SizedBox(width: 16),
                ],
                if (task.totalDays != null) ...[
                  Icon(Icons.calendar_today,
                      size: 16, color: theme.colorScheme.outline),
                  const SizedBox(width: 4),
                  Text('${task.totalDays}日間'),
                ],
              ],
            ),
          ],
          const SizedBox(height: 24),

          // 分析結果
          if (task.analysis != null)
            _buildSection(
              theme,
              title: '分析結果',
              icon: Icons.analytics,
              child: _buildAnalysis(theme, task.analysis!),
            ),

          // サブタスク
          if (task.subtasks != null && task.subtasks!.isNotEmpty)
            _buildSection(
              theme,
              title: 'サブタスク (${task.subtasks!.length}件)',
              icon: Icons.list_alt,
              child: _buildSubtasks(theme, task.subtasks!),
            ),

          // 見積もり
          if (task.estimates != null && task.estimates!.isNotEmpty)
            _buildSection(
              theme,
              title: '時間見積もり',
              icon: Icons.timer,
              child: _buildEstimates(theme, task.estimates!),
            ),

          // 優先度
          if (task.priorities != null && task.priorities!.isNotEmpty)
            _buildSection(
              theme,
              title: '優先度',
              icon: Icons.priority_high,
              child: _buildPriorities(theme, task.priorities!),
            ),

          // スケジュール
          if (task.schedule != null && task.schedule!.isNotEmpty)
            _buildSection(
              theme,
              title: 'スケジュール',
              icon: Icons.calendar_month,
              child: _buildSchedule(theme, task.schedule!),
            ),

          // 警告
          if (task.warnings != null && task.warnings!.isNotEmpty)
            _buildSection(
              theme,
              title: '警告',
              icon: Icons.warning_amber,
              child: _buildWarnings(theme, task.warnings!),
            ),
        ],
      ),
    );
  }

  Widget _buildSection(
    ThemeData theme, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: Icon(icon),
        title: Text(title, style: theme.textTheme.titleMedium),
        initiallyExpanded: true,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysis(ThemeData theme, Map<String, dynamic> analysis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: analysis.entries.map((entry) {
        final value = entry.value;
        String displayValue;
        if (value is List) {
          displayValue = value.join(', ');
        } else {
          displayValue = value.toString();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  entry.key,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(child: Text(displayValue)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubtasks(ThemeData theme, List<dynamic> subtasks) {
    return Column(
      children: subtasks.map((st) {
        final map = st as Map<String, dynamic>;
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(map['id']?.toString().split('_').last ?? '?'),
            ),
            title: Text(map['title'] ?? ''),
            subtitle: Text(map['description'] ?? ''),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEstimates(ThemeData theme, List<dynamic> estimates) {
    return Column(
      children: estimates.map((est) {
        final map = est as Map<String, dynamic>;
        final minutes = map['estimated_minutes'] as int? ?? 0;
        return ListTile(
          dense: true,
          title: Text(map['title'] ?? ''),
          trailing: Text(
            _formatMinutes(minutes),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriorities(ThemeData theme, List<dynamic> priorities) {
    return Column(
      children: priorities.map((pr) {
        final map = pr as Map<String, dynamic>;
        final priority = map['priority'] ?? '';
        Color priorityColor;
        if (priority == '高') {
          priorityColor = Colors.red;
        } else if (priority == '中') {
          priorityColor = Colors.orange;
        } else {
          priorityColor = Colors.blue;
        }
        return ListTile(
          dense: true,
          title: Text(map['title'] ?? ''),
          subtitle: Text(map['quadrant'] ?? ''),
          trailing: Chip(
            label: Text(
              priority,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            backgroundColor: priorityColor,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSchedule(ThemeData theme, List<dynamic> schedule) {
    return Column(
      children: schedule.map((sc) {
        final map = sc as Map<String, dynamic>;
        final day = map['day'] ?? 0;
        final tasks = (map['tasks'] as List<dynamic>?)?.join(', ') ?? '';
        return ListTile(
          dense: true,
          leading: CircleAvatar(
            radius: 16,
            child: Text('$day', style: const TextStyle(fontSize: 12)),
          ),
          title: Text('Day $day'),
          subtitle: Text(tasks),
        );
      }).toList(),
    );
  }

  Widget _buildWarnings(ThemeData theme, List<dynamic> warnings) {
    return Column(
      children: warnings.map((w) {
        return ListTile(
          dense: true,
          leading: Icon(Icons.warning, color: Colors.orange),
          title: Text(w.toString()),
        );
      }).toList(),
    );
  }

  String _formatMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '$hours時間${mins > 0 ? '$mins分' : ''}';
    }
    return '$mins分';
  }
}
