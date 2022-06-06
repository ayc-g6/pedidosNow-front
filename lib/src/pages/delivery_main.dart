import 'package:envios_ya/src/widgets/orders_list.dart';
import 'package:envios_ya/src/services/server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';

class DeliveryMainPage extends StatelessWidget {
  const DeliveryMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Envios Ya'),
          actions: [
            IconButton(
              onPressed: () {
                Provider.of<Auth>(context, listen: false).delete();
              },
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
        body: const OrdersList(onLoad: Server.getDeliveryOrders));
  }
}
