import 'package:envios_ya/src/models/business.dart';
import 'package:envios_ya/src/models/order.dart';
import 'package:envios_ya/src/models/product.dart';
import 'package:envios_ya/src/widgets/order_view.dart';
import 'package:flutter/material.dart';

class OrderViewPage extends StatelessWidget {
  final Product product;
  final Order order;
  final Business business;
  final void Function()? onUpdate;

  const OrderViewPage(
      {Key? key,
      required this.product,
      required this.order,
      required this.business,
      this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.id}'),
      ),
      body: OrderView(
        product: product,
        order: order,
        business: business,
        onUpdate: onUpdate,
      ),
    );
  }
}
