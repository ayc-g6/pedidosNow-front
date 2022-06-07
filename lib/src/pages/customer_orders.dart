import 'package:envios_ya/src/services/server.dart';
import 'package:envios_ya/src/widgets/orders_list.dart';
import 'package:flutter/material.dart';

class CustomerOrdersPage extends StatelessWidget {
  const CustomerOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('My Orders')),
        body: const OrdersList(onLoad: Server.getCustomerOrders));
  }
}
