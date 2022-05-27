import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthState { uninitialized, loggedOut, loggedIn }
enum AuthScope { business, customer }

extension AuthScopeParsing on String? {
  AuthScope parseAuthScope() {
    if (this == 'business') {
      return AuthScope.business;
    }
    if (this == 'customer') {
      return AuthScope.customer;
    }
    throw FormatException('cannot parse String $this to AuthScope');
  }
}

extension StringParsing on AuthScope {
  String _parseString() {
    switch (this) {
      case AuthScope.business:
        return 'business';
      case AuthScope.customer:
        return 'customer';
    }
  }
}

class Auth extends ChangeNotifier {
  String? _accessToken;
  AuthState _state;
  AuthScope? _scope;

  Auth() : _state = AuthState.uninitialized {
    loadAuth();
  }

  String? get accessToken => _accessToken;
  AuthState get state => _state;
  AuthScope get scope {
    if (_scope == null) {
      throw StateError(
          'scope of uninitialized or logged out auth does not exist');
    }
    return _scope!;
  }

  void loadAuth() async {
    const storage = FlutterSecureStorage();
    final savedAccessToken = await storage.read(key: 'accessToken');
    final savedScope = await storage.read(key: 'scope');
    await update(
        accessToken: savedAccessToken, scope: savedScope?.parseAuthScope());
  }

  /* Receives an accessToken and scope in a map and updates their values.
   * Notifies listeners if and only if there was a change in value or state.
   */
  Future<void> updateFromMap(Map<String, String> map) async {
    final accessToken = map['access_token'];
    final scope = map['scope'].parseAuthScope();
    update(accessToken: accessToken, scope: scope);
  }

  /*  Receives an accessToken and scope and updates their values. 
   *  Notifies listeners if and only if there was a change in value or state.
   */
  Future<void> update({String? accessToken, AuthScope? scope}) async {
    if (accessToken == _accessToken && _state != AuthState.uninitialized) {
      return;
    }
    const storage = FlutterSecureStorage();
    if (accessToken == null || scope == null) {
      await storage.delete(key: 'accessToken');
      await storage.delete(key: 'scope');
      _accessToken = null;
      _state = AuthState.loggedOut;
      _scope = null;
    } else {
      await storage.write(key: 'accessToken', value: accessToken);
      await storage.write(key: 'scope', value: scope._parseString());
      _accessToken = accessToken;
      _state = AuthState.loggedIn;
      _scope = scope;
    }
    notifyListeners();
  }

  /* Deletes auth access token and scope */
  Future<void> delete() async {
    await update();
  }
}
