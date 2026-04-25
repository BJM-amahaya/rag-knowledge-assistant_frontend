import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// API リクエストに Cognito の JWT (ID Token) を自動付与する Interceptor
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      final cognitoSession = session as CognitoAuthSession;

      final token = cognitoSession.userPoolTokensResult.value.idToken.raw;

      options.headers['Authorization'] = 'Bearer $token';
    } catch (e) {
      debugPrint('トークン取得エラー: $e');
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          error: e,
          message: '未ログインのためリクエストを中止しました',
        ),
      );
    }

    handler.next(options);
  }
}
