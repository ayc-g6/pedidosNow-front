import 'package:envios_ya/src/pages/products_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../services/server.dart';

class BusinessProducts extends StatelessWidget {
  const BusinessProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProductListPage(
        includesSearching: false,
        loadProducts: (index, [name]) async => Server.getBussinessProducts(
            index, Provider.of<Auth>(context, listen: false).accessToken));
  }
}
