import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ConfirmSignupPage extends ConsumerStatefulWidget {
  const ConfirmSignupPage({super.key, required this.email});

  final String email;

  @override
  ConsumerState<ConfirmSignupPage> createState() => _ConfirmSignupPageState();
}

class _ConfirmSignupPageState extends ConsumerState<ConfirmSignupPage> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('確認コードを入力してください')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: widget.email,
        confirmationCode: code,
      );

      if (!mounted) return;

      if (result.isSignUpComplete) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('確認が完了しました。ログインしてください。')),
        );
        context.go('/login');
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resend() async {
    try {
      await Amplify.Auth.resendSignUpCode(username: widget.email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('確認コードを再送しました')),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('メール確認')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${widget.email} に送信された確認コードを入力してください。',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ShadInput(
                  controller: _codeController,
                  placeholder: const Text('確認コード'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                ShadButton(
                  onPressed: _isLoading ? null : _confirm,
                  child: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: ShadProgress(),
                        )
                      : const Text('確認'),
                ),
                const SizedBox(height: 8),
                ShadButton.link(
                  onPressed: _isLoading ? null : _resend,
                  child: const Text('確認コードを再送'),
                ),
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
