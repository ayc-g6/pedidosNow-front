import 'package:envios_ya/src/pages/new_product.dart';
import 'package:flutter/material.dart';

import '../models/auth.dart';

class BussinessHomePage extends StatelessWidget {
  final Auth auth;
  const BussinessHomePage({Key? key, required this.auth}) : super(key: key);

  void _addProduct(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NewProductPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: const Text('Agregar producto'),
        onPressed: () => _addProduct(context),
      )),
    );
  }
}
