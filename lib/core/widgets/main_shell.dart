import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/views/upload_dialog.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.startsWith('/chat')) {
      currentIndex = 1;
    } else if (location.startsWith('/tasks')) {
      currentIndex = 2;
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
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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
              context.go('/documents');
              break;
            case 1:
              context.go('/chat');
              break;
            case 2:
              context.go('/tasks');
              break;
          }
        },
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              onPressed: () {
                if (location == '/documents') {
                  showShadDialog(
                    context: context,
                    builder: (context) => const UploadDialog(),
                  );
                } else {
                  context.go('/tasks/create');
                }
              },
              child: const Icon(LucideIcons.plus),
            )
          : null,
    );
  }

  String _getTitle(String location) {
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
