import 'package:envios_ya/src/models/work.dart';
import 'package:envios_ya/src/pages/business_main.dart';
import 'package:envios_ya/src/pages/delivery_main.dart';
import 'package:envios_ya/src/pages/log_in.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:envios_ya/src/models/auth.dart';

import 'src/pages/customer_product_list.dart';

void main() {
  runApp(const EnviosYaApp());
}

class EnviosYaApp extends StatelessWidget {
  const EnviosYaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Work>(
          create: (context) => Work(),
          update: (context, Auth auth, Work? work) {
            if (work == null) throw ArgumentError.notNull();
            return work..update(auth);
          },
        ),
      ],
      child: MaterialApp(
        title: 'Envios Ya',
        theme: ThemeData(
          primarySwatch: Colors.red,
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
                    return const CustomerProductList();
                  case AuthScope.business:
                    return const BusinessMainPage();
                  case AuthScope.delivery:
                    return const DeliveryMainPage();
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
