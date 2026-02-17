import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
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
      return const Center(
        child: SizedBox(width: 200, child: ShadProgress()),
      );
    }

    if (taskState.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: ShadAlert.destructive(
          icon: const Icon(LucideIcons.triangleAlert),
          title: const Text('エラー'),
          description: Text('${taskState.errorMessage}'),
        ),
      );
    }

    if (taskState.tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.listChecks,
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
            child: const Icon(LucideIcons.trash2, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            bool? result;
            await showShadDialog(
              context: context,
              builder: (context) => ShadDialog.alert(
                title: const Text('削除確認'),
                description: const Text('このタスクを削除しますか？'),
                actions: [
                  ShadButton.outline(
                    child: const Text('キャンセル'),
                    onPressed: () {
                      result = false;
                      Navigator.pop(context);
                    },
                  ),
                  ShadButton.destructive(
                    child: const Text('削除'),
                    onPressed: () {
                      result = true;
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
            return result ?? false;
          },
          onDismissed: (_) {
            ref.read(taskNotifierProvider.notifier).deleteTask(task.id);
          },
          child: ListTile(
            leading: Icon(
              LucideIcons.listChecks,
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
            trailing: const Icon(LucideIcons.chevronRight),
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
