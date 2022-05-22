import 'package:envios_ya/src/pages/log_in.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:envios_ya/src/models/auth.dart';

void main() {
  runApp(const EnviosYaApp());
}

class EnviosYaApp extends StatelessWidget {
  const EnviosYaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Envios Ya',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => Auth(),
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            switch (auth.state) {
              case AuthState.uninitialized:
                return Scaffold(body: Center(child: Text('SPLASH SCREEN')));
              case AuthState.loggedIn:
                return Scaffold(body: Center(child: Text('HOME')));
              case AuthState.loggedOut:
                return LogInPage();
            }
          },
        ),
      ),
    );
  }
}
