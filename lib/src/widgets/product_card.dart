import 'package:envios_ya/src/models/product.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(children: [
          Text(product.name),
          const SizedBox(height: 10),
          Text(product.price.toStringAsFixed(2)),
          const SizedBox(height: 10),
          Text(product.owner)
        ]),
      ),
    );
  }
}
