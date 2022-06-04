import 'package:envios_ya/src/models/product.dart';
import 'package:envios_ya/src/widgets/products_list.dart';
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
      body: ProductList(
        includesSearching: true,
        loadProducts: (index) async {
          String? accessToken =
              Provider.of<Auth>(context, listen: false).accessToken;
          // We allow exceptions to propagate to the caller Widget
          final productsData = await Server.getProducts(index);
          List<Product> products =
              List.of(productsData.map((e) => Product.fromJson(e)));
          return products;
        },
      ),
    );
  }
}
