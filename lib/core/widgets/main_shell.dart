import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/providers/document_provider.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/views/upload_dialog.dart';

class MainShell extends ConsumerWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.startsWith('/documents')) {
      currentIndex = 1;
    } else if (location.startsWith('/chat')) {
      currentIndex = 2;
    } else if (location.startsWith('/tasks')) {
      currentIndex = 3;
    }

    final title = _getTitle(location);
    final showBack = location.startsWith('/tasks/') && location != '/tasks';
    final showFab = location == '/documents' || location == '/tasks';

    return Scaffold(
      appBar: AppBar(
        leading: showBack
            ? IconButton(
                icon: const Icon(LucideIcons.arrowLeft),
                onPressed: () => context.go('/tasks'),
              )
            : null,
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.logOut),
            tooltip: 'ログアウト',
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.house),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.fileText),
            label: 'ドキュメント',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.messageCircle),
            label: 'チャット',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.listChecks),
            label: 'タスク',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/documents');
              break;
            case 2:
              context.go('/chat');
              break;
            case 3:
              context.go('/tasks');
              break;
          }
        },
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              onPressed: () async {
                if (location == '/documents') {
                  final result = await showShadDialog<bool>(
                    context: context,
                    builder: (context) => const UploadDialog(),
                  );
                  if (result == true) {
                    ref.invalidate(documentsProvider);
                  }
                } else {
                  context.go('/tasks/create');
                }
              },
              child: const Icon(LucideIcons.plus),
            )
          : null,
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final confirmed = await showShadDialog<bool>(
      context: context,
      builder: (context) => ShadDialog.alert(
        title: const Text('ログアウト'),
        description: const Text('ログアウトしますか？'),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          ShadButton.destructive(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('ログアウト'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }

  String _getTitle(String location) {
    if (location == '/home') return 'ナレッジアシスタント';
    if (location == '/documents') return 'ドキュメント';
    if (location == '/chat') return 'RAG チャット';
    if (location == '/tasks/create') return 'タスク作成';
    if (location.startsWith('/tasks/') && location != '/tasks') {
      return 'タスク詳細';
    }
    if (location == '/tasks') return 'タスク';
    return '';
  }
}
