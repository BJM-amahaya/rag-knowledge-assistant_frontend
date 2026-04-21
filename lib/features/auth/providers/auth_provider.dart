import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthStateNotifier extends ChangeNotifier {
  AuthStateNotifier() {
    _init();
  }

  bool _isSignedIn = false;
  bool _isInitialized = false;
  StreamSubscription<AuthHubEvent>? _subscription;

  bool get isSignedIn => _isSignedIn;
  bool get isInitialized => _isInitialized;

  Future<void> _init() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      _isSignedIn = session.isSignedIn;
    } on Exception catch (e) {
      debugPrint('⚠️ fetchAuthSession 失敗: $e');
      _isSignedIn = false;
    }
    _isInitialized = true;
    notifyListeners();

    _subscription = Amplify.Hub.listen(HubChannel.Auth, (event) {
      switch (event.type) {
        case AuthHubEventType.signedIn:
          _isSignedIn = true;
          notifyListeners();
          break;
        case AuthHubEventType.signedOut:
        case AuthHubEventType.sessionExpired:
        case AuthHubEventType.userDeleted:
          _isSignedIn = false;
          notifyListeners();
          break;
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final authStateProvider = Provider<AuthStateNotifier>((ref) {
  final notifier = AuthStateNotifier();
  ref.onDispose(notifier.dispose);
  return notifier;
});
