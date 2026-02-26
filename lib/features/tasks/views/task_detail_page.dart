import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
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
      return FutureBuilder<Task>(
        future: ref.read(taskServiceProvider).getTask(taskId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(width: 200, child: ShadProgress()),
            );
          }
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ShadAlert.destructive(
                icon: const Icon(LucideIcons.triangleAlert),
                title: const Text('タスクが見つかりません'),
              ),
            );
          }
          return _buildDetail(context, theme, snapshot.data!);
        },
      );
    }

    return _buildDetail(context, theme, task);
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
          task.status == 'completed'
              ? ShadBadge(
                  child: Text(task.status),
                )
              : ShadBadge.secondary(
                  child: Text(task.status),
                ),
          if (task.totalMinutes != null || task.totalDays != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                if (task.totalMinutes != null) ...[
                  Icon(LucideIcons.timer, size: 16, color: theme.colorScheme.outline),
                  const SizedBox(width: 4),
                  Text('合計 ${_formatMinutes(task.totalMinutes!)}'),
                  const SizedBox(width: 16),
                ],
                if (task.totalDays != null) ...[
                  Icon(LucideIcons.calendarDays,
                      size: 16, color: theme.colorScheme.outline),
                  const SizedBox(width: 4),
                  Text('${task.totalDays}日間'),
                ],
              ],
            ),
          ],
          const SizedBox(height: 24),

          // ShadAccordion で全セクションを表示
          ShadAccordion<String>.multiple(
            initialValue: [
              if (task.analysis != null) 'analysis',
              if (task.subtasks != null && task.subtasks!.isNotEmpty) 'subtasks',
            ],
            children: [
              // 分析結果
              if (task.analysis != null)
                ShadAccordionItem(
                  value: 'analysis',
                  title: Row(
                    children: [
                      const Icon(LucideIcons.chartBar, size: 18),
                      const SizedBox(width: 8),
                      Text('分析結果', style: theme.textTheme.titleMedium),
                    ],
                  ),
                  child: _buildAnalysis(theme, task.analysis!),
                ),

              // サブタスク
              if (task.subtasks != null && task.subtasks!.isNotEmpty)
                ShadAccordionItem(
                  value: 'subtasks',
                  title: Row(
                    children: [
                      const Icon(LucideIcons.listChecks, size: 18),
                      const SizedBox(width: 8),
                      Text('サブタスク (${task.subtasks!.length}件)',
                          style: theme.textTheme.titleMedium),
                    ],
                  ),
                  child: _buildSubtasks(theme, task.subtasks!),
                ),

              // 見積もり
              if (task.estimates != null && task.estimates!.isNotEmpty)
                ShadAccordionItem(
                  value: 'estimates',
                  title: Row(
                    children: [
                      const Icon(LucideIcons.timer, size: 18),
                      const SizedBox(width: 8),
                      Text('時間見積もり', style: theme.textTheme.titleMedium),
                    ],
                  ),
                  child: _buildEstimates(theme, task.estimates!),
                ),

              // 優先度
              if (task.priorities != null && task.priorities!.isNotEmpty)
                ShadAccordionItem(
                  value: 'priorities',
                  title: Row(
                    children: [
                      const Icon(LucideIcons.signalHigh, size: 18),
                      const SizedBox(width: 8),
                      Text('優先度', style: theme.textTheme.titleMedium),
                    ],
                  ),
                  child: _buildPriorities(theme, task.priorities!),
                ),

              // スケジュール
              if (task.schedule != null && task.schedule!.isNotEmpty)
                ShadAccordionItem(
                  value: 'schedule',
                  title: Row(
                    children: [
                      const Icon(LucideIcons.calendarDays, size: 18),
                      const SizedBox(width: 8),
                      Text('スケジュール', style: theme.textTheme.titleMedium),
                    ],
                  ),
                  child: _buildSchedule(theme, task.schedule!, task.subtasks),
                ),

              // 警告
              if (task.warnings != null && task.warnings!.isNotEmpty)
                ShadAccordionItem(
                  value: 'warnings',
                  title: Row(
                    children: [
                      const Icon(LucideIcons.triangleAlert, size: 18),
                      const SizedBox(width: 8),
                      Text('警告', style: theme.textTheme.titleMedium),
                    ],
                  ),
                  child: _buildWarnings(theme, task.warnings!),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static const _analysisLabelMap = <String, String>{
    'category': 'カテゴリ',
    'purpose': '目的',
    'urgency': '緊急度',
    'complexity': '複雑さ',
    'key_requirements': '主要な要件',
    'key_requirement': '主要な要件',
    'constraints': '制約条件',
  };

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
        final label = _analysisLabelMap[entry.key] ?? entry.key;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  label,
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
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ShadCard(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  child: Text(map['id']?.toString().split('_').last ?? '?'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(map['title'] ?? '',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      if (map['description'] != null)
                        Text(map['description'],
                            style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
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
        return ListTile(
          dense: true,
          title: Text(map['title'] ?? ''),
          subtitle: Text(map['quadrant'] ?? ''),
          trailing: priority == '高'
              ? ShadBadge.destructive(child: Text(priority))
              : ShadBadge.secondary(child: Text(priority)),
        );
      }).toList(),
    );
  }

  Widget _buildSchedule(
      ThemeData theme, List<dynamic> schedule, List<dynamic>? subtasks) {
    // バックエンド形式（scheduled_date あり）か判定
    if (schedule.isNotEmpty &&
        (schedule.first as Map<String, dynamic>)
            .containsKey('scheduled_date')) {
      return _buildBackendSchedule(theme, schedule, subtasks);
    }

    // レガシー形式（day / tasks）── 後方互換
    return Column(
      children: schedule.map((sc) {
        final map = sc as Map<String, dynamic>;
        final day = map['day'] ?? 0;
        final tasks = (map['tasks'] as List<dynamic>?)?.join(', ') ?? '';
        return ListTile(
          dense: true,
          leading: CircleAvatar(
            radius: 16,
            child: Text('$day', style: theme.textTheme.bodySmall),
          ),
          title: Text('Day $day'),
          subtitle: Text(tasks),
        );
      }).toList(),
    );
  }

  /// バックエンド形式のスケジュールを日付ごとにグループ化して表示
  Widget _buildBackendSchedule(
      ThemeData theme, List<dynamic> schedule, List<dynamic>? subtasks) {
    // subtask_id → タイトルの対応マップを構築
    final subtaskMap = <String, String>{};
    if (subtasks != null) {
      for (final st in subtasks) {
        final map = st as Map<String, dynamic>;
        final id = map['id'] as String?;
        final title = map['title'] as String?;
        if (id != null) subtaskMap[id] = title ?? id;
      }
    }

    // scheduled_date でグループ化（Map は挿入順を保持）
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final sc in schedule) {
      final map = sc as Map<String, dynamic>;
      final date = map['scheduled_date'] as String;
      grouped.putIfAbsent(date, () => []).add(map);
    }

    final dates = grouped.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: dates.asMap().entries.map((entry) {
        final dayNum = entry.key + 1;
        final date = entry.value;
        final items = grouped[date]!;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 日付ヘッダー
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    child:
                        Text('$dayNum', style: theme.textTheme.bodySmall),
                  ),
                  const SizedBox(width: 8),
                  Text('Day $dayNum',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text('($date)',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.outline)),
                ],
              ),
              // その日のタスク一覧
              ...items.map((item) {
                final subtaskId = item['subtask_id'] as String? ?? '';
                final title = subtaskMap[subtaskId] ?? subtaskId;
                final time = item['scheduled_time'] as String? ?? '';
                final duration = item['duration_minutes'] as int? ?? 0;

                return Padding(
                  padding: const EdgeInsets.only(left: 40, top: 4),
                  child: Row(
                    children: [
                      if (time.isNotEmpty) ...[
                        Text(time,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        const Text('-'),
                        const SizedBox(width: 8),
                      ],
                      Expanded(child: Text(title)),
                      if (duration > 0)
                        Text('(${_formatMinutes(duration)})',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: theme.colorScheme.outline)),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWarnings(ThemeData theme, List<dynamic> warnings) {
    return Column(
      children: warnings.map((w) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ShadAlert.destructive(
            icon: const Icon(LucideIcons.triangleAlert),
            title: Text(w.toString()),
          ),
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
