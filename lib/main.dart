import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:rag_knowledge_assistant_frontend/core/router/app_router.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.router(
      routerConfig: appRouter,
      themeMode: ThemeMode.light,
      theme: ShadThemeData(
        colorScheme: const ShadVioletColorScheme.light(),
        brightness: Brightness.light,
      ),
      darkTheme: ShadThemeData(
        colorScheme: const ShadVioletColorScheme.dark(),
        brightness: Brightness.dark,
      ),
    );
  }
}
