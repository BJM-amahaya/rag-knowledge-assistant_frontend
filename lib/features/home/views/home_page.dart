import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:rag_knowledge_assistant_frontend/features/home/providers/home_provider.dart';
import 'package:rag_knowledge_assistant_frontend/features/home/widgets/quick_chat_bar.dart';
import 'package:rag_knowledge_assistant_frontend/features/home/widgets/quick_action_chips.dart';
import 'package:rag_knowledge_assistant_frontend/features/home/widgets/activity_card.dart';
import 'package:rag_knowledge_assistant_frontend/features/home/widgets/date_header.dart';
import 'package:rag_knowledge_assistant_frontend/features/home/widgets/empty_home_state.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/providers/document_provider.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/providers/task_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // 初回データフェッチ
    Future.microtask(() {
      ref.read(documentNotifierProvider.notifier).fetchDocuments();
      ref.read(taskNotifierProvider.notifier).fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = ref.watch(homeLoadingProvider);
    final grouped = ref.watch(groupedActivityProvider);
    final hasData = grouped.isNotEmpty;

    return CustomScrollView(
      slivers: [
        // 検索バー + クイックアクション（常に表示）
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              QuickChatBar(),
              QuickActionChips(),
            ],
          ),
        ),

        // セクションヘッダー
        if (hasData)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: theme.colorScheme.outline.withAlpha(51),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '最近のアクティビティ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: theme.colorScheme.outline.withAlpha(51),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // ローディング
        if (isLoading && !hasData)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: SizedBox(width: 200, child: ShadProgress()),
              ),
            ),
          ),

        // 空状態
        if (!isLoading && !hasData)
          const SliverToBoxAdapter(child: EmptyHomeState()),

        // アクティビティフィード
        if (hasData)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final sortedDates = grouped.keys.toList()
                  ..sort((a, b) => b.compareTo(a));

                // 日付 + その日のアイテムをフラット化したリストを構築
                int currentIndex = 0;
                for (final date in sortedDates) {
                  // 日付ヘッダー
                  if (currentIndex == index) {
                    return DateHeader(date: date);
                  }
                  currentIndex++;

                  // その日のアイテム
                  final items = grouped[date]!;
                  for (final item in items) {
                    if (currentIndex == index) {
                      return ActivityCard(item: item);
                    }
                    currentIndex++;
                  }
                }
                return null;
              },
              childCount: _calcTotalCount(grouped),
            ),
          ),

        // 下部の余白
        const SliverToBoxAdapter(
          child: SizedBox(height: 16),
        ),
      ],
    );
  }

  int _calcTotalCount(Map<DateTime, List<dynamic>> grouped) {
    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    int count = 0;
    for (final date in sortedDates) {
      count++; // 日付ヘッダー
      count += grouped[date]!.length; // アイテム数
    }
    return count;
  }
}
