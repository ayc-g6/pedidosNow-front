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
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductViewPage(product: product, business: business)),
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
                  Expanded(
                    child: Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleLarge,
                    ),
                  ),
                  Text(
                    "${product.price.toStringAsFixed(2)} \$",
                    style: textTheme.headline6!.copyWith(color: Colors.green),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8.0),
              Text("${business.name} - ${business.address}",
                  style: textTheme.titleSmall),
              const SizedBox(height: 16.0),
              Text(product.description),
            ],
          ),
        ),
      ),
    );
  }
}
