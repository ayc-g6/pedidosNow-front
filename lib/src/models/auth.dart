import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth extends ChangeNotifier {
  String? _userID;
  String? _sessionToken;

  Auth() {
    // loadAuth();
  }

  String? get sessionToken => _sessionToken;

  void loadAuth() async {
    const storage = FlutterSecureStorage();
  }

  void setAuth(String userID,String sessionToken) {
    _userID = userID;
    _sessionToken = sessionToken;
    notifyListeners();
  }

  void deleteAuth() {
    _userID = null;
    _sessionToken = null;
    notifyListeners();
  }
}