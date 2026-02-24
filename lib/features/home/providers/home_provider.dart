import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rag_knowledge_assistant_frontend/features/home/models/activity_item.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/providers/document_provider.dart';
import 'package:rag_knowledge_assistant_frontend/features/chat/providers/chat_provider.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/providers/task_provider.dart';

/// 全アクティビティを日付降順で返すProvider
final activityProvider = Provider<List<ActivityItem>>((ref) {
  final docState = ref.watch(documentNotifierProvider);
  final chatState = ref.watch(chatNotifierProvider);
  final taskState = ref.watch(taskNotifierProvider);

  final items = <ActivityItem>[];

  // ドキュメント → ActivityItem
  for (final doc in docState.documents) {
    items.add(ActivityItem.fromDocument(
      name: doc.name,
      uploadedAt: doc.uploadedAt,
      size: doc.size,
    ));
  }

  // チャットメッセージ（ユーザーのみ）→ ActivityItem
  for (final msg in chatState.messages) {
    if (msg.isUser) {
      items.add(ActivityItem.fromChat(
        content: msg.content,
        timestamp: msg.timestamp,
      ));
    }
  }

  // タスク → ActivityItem
  for (final task in taskState.tasks) {
    items.add(ActivityItem.fromTask(
      taskName: task.task,
      status: task.status,
      createdAt: task.createdAt,
      subtaskCount: task.subtasks?.length,
      totalMinutes: task.totalMinutes,
    ));
  }

  // 日付降順ソート
  items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  return items;
});

/// アクティビティを日付ごとにグループ化
final groupedActivityProvider =
    Provider<Map<DateTime, List<ActivityItem>>>((ref) {
  final items = ref.watch(activityProvider);
  final grouped = <DateTime, List<ActivityItem>>{};

  for (final item in items) {
    final dateKey = DateTime(
      item.timestamp.year,
      item.timestamp.month,
      item.timestamp.day,
    );
    grouped.putIfAbsent(dateKey, () => []).add(item);
  }

  return grouped;
});

/// データ読み込み中かどうか
final homeLoadingProvider = Provider<bool>((ref) {
  final docState = ref.watch(documentNotifierProvider);
  final taskState = ref.watch(taskNotifierProvider);
  return docState.isLoading || taskState.isLoading;
});
