import 'package:envios_ya/src/models/product.dart';
import 'package:envios_ya/src/widgets/products_list.dart';
import 'package:envios_ya/src/observers/page_reloader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../services/server.dart';

class BusinessProducts extends StatelessWidget {
  final PageReloadObserver reloadObserver;

  const BusinessProducts({Key? key, required this.reloadObserver})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProductList(
      loadProducts: (index) async {
        String? accessToken =
            Provider.of<Auth>(context, listen: false).accessToken;
        // We allow exceptions to propagate to the caller Widget
        final productsData =
            await Server.getBussinessProducts(index, accessToken);
        List<Product> products =
            List.of(productsData.map((e) => Product.fromJson(e)));
        return products;
      },
      pageReloadObserver: reloadObserver,
    );
  }
}
