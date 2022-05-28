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
        height: 150,
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(widget.product.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      subtitle: Text("De: ${widget.product.owner}"),
                    ),
                  ),
                  Expanded(
                    child: Text("\$${widget.product.price}",
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.only(right: 5),
                  child: ElevatedButton(
                    child: Text("Ver información nutricional"),
                    //TODO: go to te info nutri page
                    onPressed: () => {},
                  ),
                ),
              ),
            ],
          ),
          elevation: 8,
          margin: EdgeInsets.all(10),
        ),
      ),
    );
  }
}
