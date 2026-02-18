import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

enum ActivityType { document, chat, task }

class ActivityItem {
  final ActivityType type;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final IconData icon;
  final Color color;
  final String? navigateTo;

  const ActivityItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.icon,
    required this.color,
    this.navigateTo,
  });

  factory ActivityItem.fromDocument({
    required String name,
    required DateTime uploadedAt,
    int? size,
  }) {
    final sizeText = size != null
        ? ' (${(size / 1024 / 1024).toStringAsFixed(1)}MB)'
        : '';
    return ActivityItem(
      type: ActivityType.document,
      title: 'ドキュメントをアップロード',
      subtitle: '$name$sizeText',
      timestamp: uploadedAt,
      icon: LucideIcons.fileUp,
      color: const Color(0xFF3B82F6),
      navigateTo: '/documents',
    );
  }

  factory ActivityItem.fromChat({
    required String content,
    required DateTime timestamp,
  }) {
    final truncated =
        content.length > 40 ? '${content.substring(0, 40)}...' : content;
    return ActivityItem(
      type: ActivityType.chat,
      title: 'チャットで質問しました',
      subtitle: truncated,
      timestamp: timestamp,
      icon: LucideIcons.messageCircle,
      color: const Color(0xFF8B5CF6),
      navigateTo: '/chat',
    );
  }

  factory ActivityItem.fromTask({
    required String taskName,
    required String status,
    required DateTime createdAt,
    int? subtaskCount,
    int? totalMinutes,
  }) {
    final isComplete = status == 'completed';
    final details = <String>[];
    if (subtaskCount != null && subtaskCount > 0) {
      details.add('$subtaskCountサブタスク');
    }
    if (totalMinutes != null && totalMinutes > 0) {
      final hours = totalMinutes ~/ 60;
      final mins = totalMinutes % 60;
      if (hours > 0) {
        details.add('$hours時間${mins > 0 ? '$mins分' : ''}');
      } else {
        details.add('$mins分');
      }
    }
    final subtitle = details.isNotEmpty
        ? '「$taskName」\n${details.join(' / ')}'
        : '「$taskName」';

    return ActivityItem(
      type: ActivityType.task,
      title: isComplete ? 'タスク分析が完了' : 'タスクを作成',
      subtitle: subtitle,
      timestamp: createdAt,
      icon: isComplete ? LucideIcons.circleCheck : LucideIcons.listChecks,
      color: const Color(0xFF10B981),
      navigateTo: '/tasks',
    );
  }
}
