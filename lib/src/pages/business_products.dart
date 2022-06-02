import 'package:envios_ya/src/pages/new_product.dart';
import 'package:flutter/material.dart';

class BusinessProducts extends StatelessWidget {
  const BusinessProducts({Key? key}) : super(key: key);

  void _addProduct(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NewProductPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Add product'),
      onPressed: () => _addProduct(context),
    );
  }
}
