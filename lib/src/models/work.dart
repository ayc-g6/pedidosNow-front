import 'package:envios_ya/src/models/auth.dart';
import 'package:envios_ya/src/services/server.dart';
import 'package:flutter/material.dart';

enum WorkState { uninitialized, free, busy }

class Work with ChangeNotifier {
  WorkState _state;
  int? _workId;

  Work() : _state = WorkState.uninitialized;

  WorkState get state => _state;
  int? get workId => _workId;

  void update(Auth auth) async {
    if (auth.state != AuthState.loggedIn || auth.scope != AuthScope.delivery) {
      _workId = null;
      _state = WorkState.uninitialized;
      return;
    }
    try {
      int orderId = await Server.getWork(auth.accessToken!);
      _workId = orderId;
      _state = WorkState.busy;
    } on ServerException catch (error) {
      if (error.isAuthException()) {
        auth.delete();
      }
      _workId = null;
      _state = WorkState.free;
    }
    notifyListeners();
  }
}
