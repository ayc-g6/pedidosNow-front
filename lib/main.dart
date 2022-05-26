import 'package:envios_ya/src/pages/log_in.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:envios_ya/src/models/auth.dart';

import 'package:envios_ya/src/pages/new_product.dart';
void main() {
  runApp(const EnviosYaApp());
}

class EnviosYaApp extends StatelessWidget {
  const EnviosYaApp({Key? key}) : super(key: key);

  void _addProduct(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NewProductPage(),
      ),
    );
  }

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
                switch (auth.scope) {
                    case AuthScope.customer:
                        return Scaffold(
                          appBar: AppBar(
                            actions: [
                              IconButton(
                                onPressed: () => auth.delete(),
                                icon: const Icon(Icons.logout_rounded),
                              ),
                            ],
                          ),
                          body: Center(
                              child: Text('No se puede comprar todavía :(')
                          ),
                        );
                    case AuthScope.business:
                        return Scaffold(
                          appBar: AppBar(
                            actions: [
                              IconButton(
                                onPressed: () => auth.delete(),
                                icon: const Icon(Icons.logout_rounded),
                              ),
                            ],
                          ),
                          body: Center(
                              child: ElevatedButton(
                                child: Text('Agregar producto'),
                                onPressed: () => _addProduct(context),
                              )
                          ),
                        );
                }
              case AuthState.loggedOut:
                return LogInPage();
            }
          },
        ),
      ),
    );
  }
}
