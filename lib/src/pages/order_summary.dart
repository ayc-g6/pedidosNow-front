import 'package:envios_ya/src/models/product.dart';
import 'package:envios_ya/src/services/server.dart';
import '../models/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class OrderSummaryPage extends StatefulWidget {
  final Product product;

  const OrderSummaryPage({Key? key, required this.product}) : super(key: key);

  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  bool _isLoading = false;

  void _createOrder() async {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();
    Auth auth = Provider<Auth>.of(context, listen: false);
    try {
        await Server.createOrder(widget.product);
      } on ServerException catch (e) {
        if (!mounted) return;
        final snackBar = SnackBar(content: Text(e.message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Envios Ya"),
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
                    subtitle: Text("De: ${widget.product.owner} | ${widget.product.price}"),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text("Total: \$${widget.product.price}",
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.only(left: 5),
                        child: ElevatedButton(
                          child: const Text("Comprar"),
                          onPressed: () async => _createOrder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            elevation: 8,
            margin: const EdgeInsets.only(bottom: 10)),
      ),
    );
  }
}
