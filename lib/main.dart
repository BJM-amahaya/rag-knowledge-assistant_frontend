import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'amplifyconfiguration.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:rag_knowledge_assistant_frontend/core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _configureAmplify() async {
  try {
    final auth = AmplifyAuthCognito();
    await Amplify.addPlugin(auth);
    await Amplify.configure(amplifyconfig);
    debugPrint('✅ Amplify 初期化完了');
  } on AmplifyAlreadyConfiguredException {
    debugPrint('⚠️ Amplify はすでに初期化済み（ホットリスタート後）');
  } catch (e) {
    debugPrint('❌ Amplify 初期化エラー: $e');
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShadApp.router(
      routerConfig: ref.watch(appRouterProvider),
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
