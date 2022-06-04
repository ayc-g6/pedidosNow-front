import 'package:envios_ya/src/models/business.dart';
import 'package:envios_ya/src/models/product.dart';
import 'package:envios_ya/src/pages/product_view.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Business business;

  const ProductCard({Key? key, required this.product, required this.business})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductViewPage(product: product)),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    "${product.price.toStringAsFixed(2)} \$",
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("${business.name} - ${business.address}"),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(product.description),
            ],
          ),
        ),
      ),
    );
  }
}
