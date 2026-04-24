import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      ShadSonner.of(context).show(
        const ShadToast(title: Text('パスワードが一致しません')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(
          userAttributes: {
            AuthUserAttributeKey.email: email,
          },
        ),
      );

      if (!mounted) return;

      if (result.isSignUpComplete) {
        ShadSonner.of(context).show(
          const ShadToast(title: Text('登録が完了しました。ログインしてください。')),
        );
        context.go('/login');
      } else {
        context.go('/confirm-signup', extra: email);
      }
    } on AuthException catch (e) {
      if (mounted) {
        ShadSonner.of(context).show(
          ShadToast(title: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('アカウント作成')),
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
                  placeholder: const Text('パスワード（8文字以上）'),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ShadInput(
                  controller: _confirmPasswordController,
                  placeholder: const Text('パスワード（確認）'),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ShadButton(
                  onPressed: _isLoading ? null : _signUp,
                  child: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: ShadProgress(),
                        )
                      : const Text('アカウント作成'),
                ),
                const SizedBox(height: 8),
                ShadButton.link(
                  onPressed: () => context.go('/login'),
                  child: const Text('ログイン画面に戻る'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
