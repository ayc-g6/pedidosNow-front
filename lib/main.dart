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
            bool isLoggedIn = auth.sessionToken != null;
            Navigator.popUntil(context, (route) => route.isFirst);
            if (!isLoggedIn) {
              // Navigator.push(PAGINA LOGIN) 
            } else {
              //Navigator.popUntil(context, (route) => )
            }
            return Scaffold(body: Center(child: Text('LOGO APP'),),);
          }
        )
      ),
    );
  }
}
