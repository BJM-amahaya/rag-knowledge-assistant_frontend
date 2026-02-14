import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/models/task.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/providers/task_provider.dart';

class TaskPage extends ConsumerStatefulWidget {
  const TaskPage({super.key});

  @override
  ConsumerState<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
  @override
  void initState() {
    super.initState();
    // 画面表示時にタスク一覧を取得
    Future.microtask(() {
      ref.read(taskNotifierProvider.notifier).fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskState = ref.watch(taskNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('タスク')),
      body: _buildBody(theme, taskState),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/tasks/create'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, taskState) {
    if (taskState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (taskState.errorMessage != null) {
      return Center(
        child: Text(
          'エラー: ${taskState.errorMessage}',
          style: TextStyle(color: theme.colorScheme.error),
        ),
      );
    }

    if (taskState.tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'AIにタスクを分析してもらいましょう',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '右下の + ボタンから\n新しいタスクを作成できます',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: taskState.tasks.length,
      itemBuilder: (context, index) {
        final task = taskState.tasks[index];
        return Dismissible(
          key: Key(task.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: theme.colorScheme.error,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('削除確認'),
                content: const Text('このタスクを削除しますか？'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('キャンセル'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('削除'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (_) {
            ref.read(taskNotifierProvider.notifier).deleteTask(task.id);
          },
          child: ListTile(
            leading: Icon(
              Icons.task_alt,
              color: task.status == 'completed'
                  ? Colors.green
                  : theme.colorScheme.primary,
            ),
            title: Text(
              task.task,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              _formatSubtitle(task),
              style: theme.textTheme.bodySmall,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/tasks/${task.id}'),
          ),
        );
      },
    );
  }

  String _formatSubtitle(Task task) {
    final parts = <String>[];
    if (task.totalMinutes != null) {
      final hours = task.totalMinutes! ~/ 60;
      final minutes = task.totalMinutes! % 60;
      if (hours > 0) {
        parts.add('$hours時間${minutes > 0 ? '$minutes分' : ''}');
      } else {
        parts.add('$minutes分');
      }
    }
    if (task.totalDays != null) {
      parts.add('${task.totalDays}日間');
    }
    if (task.subtasks != null) {
      parts.add('${task.subtasks!.length}サブタスク');
    }
    return parts.isEmpty ? task.status : parts.join(' / ');
  }
}
