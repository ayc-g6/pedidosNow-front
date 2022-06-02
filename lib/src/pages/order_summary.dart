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
  int _quantity = 1;

  void _createOrder() async {
    FocusScope.of(context).unfocus();
    Auth auth = Provider.of<Auth>(context, listen: false);
    try {
      /* FIXME Incorrecto. Mandar el Auth.accessToken directamente 
         * como header en createOrder. Luego, createOrder utiliza get_current_id
         * para saber quien le está hablando. Si no se entiende preguntenme. --Santi
        */
      String? customerId = await Server.getUserId(auth.accessToken);
      await Server.createOrder(widget.product, customerId);
    } on ServerException catch (e) {
      if (!mounted) return;
      final snackBar = SnackBar(content: Text(e.message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Envios Ya"),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Tu compra", 
                    style: Theme.of(context).textTheme.titleLarge
                  )
                ),
                Row(
                  children: [
                    const Icon(Icons.fastfood_outlined),
                    Expanded(
                      child: ListTile(
                        title: Text(widget.product.name,
                          style: Theme.of(context).textTheme.titleLarge),
                        //subtitle: Text("${widget.product.owner}\n\$${widget.product.price}") TODO check this
                      )
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => setState(() {
                        if (_quantity > 1) {
                          _quantity--;
                        }
                      }), 
                    ),
                    Container(
                      width: 48.0,
                      alignment: Alignment.center,
                      child: Text(
                        '$_quantity',
                        style: Theme.of(context).textTheme.bodyMedium
                      )
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() { _quantity++; }), 
                    ),
                  ]
                ),
                ElevatedButton(
                  child: Text("Comprar \$" + (_quantity * widget.product.price).toStringAsFixed(2)),
                  onPressed: () async => _createOrder(),
                )
              ]),
            ),
          elevation: 8.0,
          margin: const EdgeInsets.all(16.0)),
      ),
    );
  }
}
