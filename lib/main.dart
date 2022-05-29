import 'package:envios_ya/src/pages/bussiness_home.dart';
import 'package:envios_ya/src/pages/log_in.dart';
import 'package:envios_ya/src/pages/nutrition_facts.dart';
import 'package:envios_ya/src/pages/products_list.dart';
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
    return ChangeNotifierProvider(
      create: (context) => Auth(),
      child: MaterialApp(
        title: 'Envios Ya',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<Auth>(
          builder: (context, auth, child) {
            switch (auth.state) {
              case AuthState.uninitialized:
                return const Scaffold(
                    body: Center(child: Text('SPLASH SCREEN')));
              case AuthState.loggedIn:
                switch (auth.scope) {
                  case AuthScope.customer:
                    return ProductListPage();
                  case AuthScope.business:
                    return BussinessHomePage();
                }
              case AuthState.loggedOut:
                return const LogInPage();
            }
          },
        ),
      ),
    );
  }
}
