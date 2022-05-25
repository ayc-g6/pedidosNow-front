import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthState { uninitialized, loggedOut, loggedIn }

class Auth extends ChangeNotifier {
  String? _accessToken;
  AuthState _state;

  Auth() : _state = AuthState.uninitialized {
    loadAuth();
  }

  String? get accessToken => _accessToken;
  AuthState get state => _state;

  void loadAuth() async {
    const storage = FlutterSecureStorage();
    final savedAccessToken = await storage.read(key: 'accessToken');
    await updateAuth(savedAccessToken);
  }

  /*  Receives an accessToken and updates its value. 
   *  Notifies listeners if and only if there was a change in value or state.
   */
  Future<void> updateAuth(String? accessToken) async {
    if (accessToken == _accessToken && _state != AuthState.uninitialized) {
      return;
    }
    const storage = FlutterSecureStorage();
    if (accessToken == null) {
      await storage.delete(key: 'accessToken');
      _accessToken = null;
      _state = AuthState.loggedOut;
    } else {
      await storage.write(key: 'accessToken', value: accessToken);
      _accessToken = accessToken;
      _state = AuthState.loggedIn;
    }
    notifyListeners();
  }

  Future<void> deleteAuth() async {
    await updateAuth(null);
  }
}
