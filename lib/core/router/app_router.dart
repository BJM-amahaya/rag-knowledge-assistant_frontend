import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rag_knowledge_assistant_frontend/core/widgets/main_shell.dart';
import 'package:rag_knowledge_assistant_frontend/features/auth/providers/auth_provider.dart';
import 'package:rag_knowledge_assistant_frontend/features/auth/views/confirm_signup_page.dart';
import 'package:rag_knowledge_assistant_frontend/features/auth/views/login_page.dart';
import 'package:rag_knowledge_assistant_frontend/features/auth/views/signup_page.dart';
import 'package:rag_knowledge_assistant_frontend/features/chat/views/chat_page.dart';
import 'package:rag_knowledge_assistant_frontend/features/documents/views/document_page.dart';
import 'package:rag_knowledge_assistant_frontend/features/home/views/home_page.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/views/task_create_page.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/views/task_detail_page.dart';
import 'package:rag_knowledge_assistant_frontend/features/tasks/views/task_page.dart';

const _publicRoutes = {'/login', '/signup', '/confirm-signup'};

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: authState,
    redirect: (context, state) {
      if (!authState.isInitialized) return null;

      final location = state.matchedLocation;
      final isPublic = _publicRoutes.contains(location);

      if (!authState.isSignedIn && !isPublic) return '/login';
      if (authState.isSignedIn && isPublic) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/confirm-signup',
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return ConfirmSignupPage(email: email);
        },
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),
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
});
