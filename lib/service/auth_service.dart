
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gitshiwam/models/access_token_model.dart';

class AuthService {
  static const String _url = '/login/';
  static const _storage = FlutterSecureStorage();

  static Future<bool> get isAuthenticated async {
    final token = await _storage.read(key: 'accessToken');
    debugPrint('Auth token ${token ?? 'not found.'}');
    if (token != null) {
      return true;
    }
    return false;
  }

  static void storeAccessToken(AccessTokenModel accessTokenModel) async {
    await _storage.write(
        key: 'accessToken', value: accessTokenModel.accessToken);
    await _storage.write(key: 'scope', value: accessTokenModel.scope);
  }

  static Future<String?> getAccessTokenFromDevice() async {
    final accessToken = await _storage.read(key: 'accessToken');
    if (accessToken != null) {
      return accessToken;
    }
    return null;
  }

  static String get scopeString => scopes.join(' ');
  static const List<String> scopes = [
    'repo',
    'public_repo',
    'repo:invite',
    'write:org',
    'gist',
    'notifications',
    'user',
    'delete_repo',
    'write:discussion',
    'read:packages',
    'delete:packages',
  ];

  static void logOut() async {
    await _storage.deleteAll();
  }
}
