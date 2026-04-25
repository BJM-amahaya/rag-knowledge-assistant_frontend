import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      final result = await Amplify.Auth.signIn(
        username: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (result.isSignedIn && mounted) {
        context.go('/home');
      }
    } on AuthException catch (e) {
      if (mounted) {
        ShadSonner.of(context).show(ShadToast(title: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ShadInput(
                  controller: _emailController,
                  placeholder: const Text('メールアドレス'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                ShadInput(
                  controller: _passwordController,
                  placeholder: const Text('パスワード'),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ShadButton(
                  onPressed: _isLoading ? null : _signIn,
                  child: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: ShadProgress(),
                        )
                      : const Text('ログイン'),
                ),
                const SizedBox(height: 8),
                ShadButton.link(
                  onPressed: () => context.go('/signup'),
                  child: const Text('アカウント作成はこちら'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
