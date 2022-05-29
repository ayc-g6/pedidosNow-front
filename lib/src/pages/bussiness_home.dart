import 'package:envios_ya/src/pages/new_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';

class BussinessHomePage extends StatelessWidget {
  const BussinessHomePage({Key? key}) : super(key: key);

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
            onPressed: () {
              Provider.of<Auth>(context, listen: false).delete();
            },
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
