import 'package:flutter/material.dart';

// Dummy object
class Order {}

class BusinessOrder extends StatelessWidget {
  final Order order;

  const BusinessOrder({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
