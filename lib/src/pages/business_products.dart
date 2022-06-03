import 'package:envios_ya/src/pages/products_list.dart';
import 'package:envios_ya/src/widgets/page_reloader.dart';
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
    return ProductListPage(
      loadProducts: (index) async => Server.getBussinessProducts(
          index, Provider.of<Auth>(context, listen: false).accessToken),
      pageReloadObserver: reloadObserver,
    );
  }
}
