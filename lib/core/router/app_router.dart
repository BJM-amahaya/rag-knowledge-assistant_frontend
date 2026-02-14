import 'package:go_router/go_router.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/views/document_page.dart';
import 'package:rag_knowledge_assistant_frontend/features/chat/views/chat_page.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/views/task_page.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/views/task_create_page.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/views/task_detail_page.dart';
import 'package:rag_knowledge_assistant_frontend/core/widgets/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/documents',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/documents',
          builder: (context, state) => DocumentPage(),
        ),
        GoRoute(path: '/chat', builder: (context, state) => ChatPage()),
        GoRoute(
          path: '/tasks',
          builder: (context, state) => const TaskPage(),
        ),
        GoRoute(
          path: '/tasks/create',
          builder: (context, state) => const TaskCreatePage(),
        ),
        GoRoute(
          path: '/tasks/:taskId',
          builder: (context, state) =>
              TaskDetailPage(taskId: state.pathParameters['taskId']!),
        ),
      ],
    ),
  ],
);
