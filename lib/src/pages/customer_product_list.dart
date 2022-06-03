import 'package:envios_ya/src/pages/products_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../services/server.dart';

class CustomerProductList extends StatelessWidget {
  const CustomerProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product list'),
          actions: [
            IconButton(
              onPressed: () {
                Provider.of<Auth>(context, listen: false).delete();
              },
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
        body: ProductListPage(
            loadProducts: (index) async => Server.getProducts(index)));
  }
}
