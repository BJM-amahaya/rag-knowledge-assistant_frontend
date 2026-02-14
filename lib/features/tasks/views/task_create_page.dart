import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/models/agent_progress.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/providers/task_provider.dart';

class TaskCreatePage extends ConsumerStatefulWidget {
  const TaskCreatePage({super.key});

  @override
  ConsumerState<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends ConsumerState<TaskCreatePage> {
  final _controller = TextEditingController();
  bool _hasStarted = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnalysis() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _hasStarted = true);

    // ユニークなID（タイムスタンプベース）
    final taskId = DateTime.now().millisecondsSinceEpoch.toString();
    ref.read(taskNotifierProvider.notifier).startStreaming(taskId, text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskState = ref.watch(taskNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('タスク作成')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 入力エリア
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'タスクの内容',
                hintText: '例: ECサイトの開発',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              enabled: !_hasStarted,
            ),
            const SizedBox(height: 16),

            // 分析開始ボタン
            if (!_hasStarted)
              ElevatedButton.icon(
                onPressed: _startAnalysis,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('AI分析を開始'),
              ),

            const SizedBox(height: 24),

            // Agent 進捗表示
            if (_hasStarted) ...[
              Text(
                'AI Agent 処理状況',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _buildProgressList(theme, taskState),
              ),
            ],

            // 完了後のボタン
            if (_hasStarted && !taskState.isProcessing)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref.read(taskNotifierProvider.notifier).resetProgress();
                    ref.read(taskNotifierProvider.notifier).fetchTasks();
                    context.go('/tasks');
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('タスク一覧に戻る'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressList(ThemeData theme, taskState) {
    final completedAgents = <String>{};
    for (final step in taskState.progressSteps) {
      final name = step.agentName;
      if (name != null) completedAgents.add(name);
    }

    return ListView.builder(
      itemCount: AgentProgress.agentOrder.length,
      itemBuilder: (context, index) {
        final agentKey = AgentProgress.agentOrder[index];
        final label =
            AgentProgress.agentLabels[agentKey] ?? agentKey;
        final isCompleted = completedAgents.contains(agentKey);
        final isCurrent = taskState.currentStep == agentKey;

        IconData icon;
        Color iconColor;
        if (isCompleted) {
          icon = Icons.check_circle;
          iconColor = Colors.green;
        } else if (isCurrent) {
          icon = Icons.hourglass_top;
          iconColor = theme.colorScheme.primary;
        } else {
          icon = Icons.circle_outlined;
          iconColor = theme.colorScheme.outline;
        }

        return ListTile(
          leading: isCurrent
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(icon, color: iconColor),
          title: Text(
            '${index + 1}. $label',
            style: TextStyle(
              fontWeight:
                  isCompleted || isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isCompleted
                  ? Colors.green
                  : isCurrent
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
            ),
          ),
          subtitle: isCompleted
              ? Text('完了', style: TextStyle(color: Colors.green))
              : isCurrent
                  ? Text('処理中...', style: TextStyle(color: theme.colorScheme.primary))
                  : Text('待機中', style: TextStyle(color: theme.colorScheme.outline)),
        );
      },
    );
  }
}
