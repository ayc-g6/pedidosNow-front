import 'package:envios_ya/src/models/product.dart';
import 'package:envios_ya/src/pages/order_confirmation.dart';
import 'package:flutter/material.dart';

class OrderSummaryPage extends StatefulWidget {
  final Product product;

  const OrderSummaryPage({Key? key, required this.product}) : super(key: key);

  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Envios Ya"),
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Your purchase",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.fastfood_outlined),
                    Expanded(
                      child: ListTile(
                          title: Text(
                            widget.product.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: Text(
                              "\$${widget.product.price}") // TODO: Try to put the owner's name here too
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(
                          () {
                            if (_quantity > 1) {
                              _quantity--;
                            }
                          },
                        );
                      },
                    ),
                    Container(
                      width: 48.0,
                      alignment: Alignment.center,
                      child: Text('$_quantity',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16.0),
                    Chip(
                      backgroundColor: Colors.red,
                      label: Text(
                          '\$ ${(_quantity * widget.product.price).toStringAsFixed(2)}'),
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      child: const Text("BUY"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderConfirmationPage(
                                product: widget.product, quantity: _quantity),
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          elevation: 8.0,
          margin: const EdgeInsets.all(16.0),
        ),
      ),
    );
  }
}
