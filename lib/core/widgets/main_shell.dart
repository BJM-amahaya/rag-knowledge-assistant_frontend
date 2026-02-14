import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'ドキュメント',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'チャット'),
          BottomNavigationBarItem(
              icon: Icon(Icons.task_alt), label: 'タスク'),
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
    );
  }
}
