import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthState { uninitialized, loggedOut, loggedIn }

class Auth extends ChangeNotifier {
  String? _userID;
  String? _sessionToken;
  AuthState _state;

  Auth() : _state = AuthState.uninitialized {
    loadAuth();
  }

  String? get sessionToken => _sessionToken;
  AuthState get state => _state;

  void loadAuth() async {
    const storage = FlutterSecureStorage();
    final savedUserID = await storage.read(key: 'userID');
    final savedSessionToken = await storage.read(key: 'sessionToken');
    await updateAuth(savedUserID, savedSessionToken);
  }

  Future<void> updateAuth(String? userID, String? sessionToken) async {
    const storage = FlutterSecureStorage();
    if (userID != null && sessionToken != null) {
      await storage.write(key: 'userID', value: userID);
      await storage.write(key: 'sessionToken', value: sessionToken);
      _userID = userID;
      _sessionToken = sessionToken;
      _state = AuthState.loggedIn;
    } else {
      await storage.delete(key: 'userID');
      await storage.delete(key: 'sessionToken');
      _userID = null;
      _sessionToken = null;
      _state = AuthState.loggedOut;
    }
    notifyListeners();
  }

  Future<void> deleteAuth() async {
    await updateAuth(null, null);
  }
}
