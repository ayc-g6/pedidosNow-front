import 'package:envios_ya/src/models/product.dart';
import 'package:flutter/material.dart';

class ProductViewPage extends StatefulWidget {
  final Product product;

  const ProductViewPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductViewPageState createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Envios Ya"),
        automaticallyImplyLeading: true,
      ),
      body: Container(
        height: 200,
        child: Card(
            child: Column(
              children: [
                Expanded(
                  child: ListTile(
                    minVerticalPadding: 30,
                    title: Text(widget.product.name,
                        style: Theme.of(context).textTheme.titleLarge),
                    subtitle: Text("De: ${widget.product.owner}"),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        margin: EdgeInsets.only(left: 5),
                        child: ElevatedButton(
                          child: Text("Ver información nutricional"),
                          //TODO: go to te info nutri page
                          onPressed: () => {},
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text("\$${widget.product.price}",
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                  ],
                ),
              ],
            ),
            elevation: 8,
            margin: EdgeInsets.only(bottom: 10)),
      ),
    );
  }
}
