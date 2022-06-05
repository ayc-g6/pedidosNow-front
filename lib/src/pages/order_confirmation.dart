import 'package:envios_ya/src/models/product.dart';
import 'package:envios_ya/src/pages/successful_purchase.dart';
import 'package:envios_ya/src/services/server.dart';
import '../models/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatefulWidget {
  final Product product;
  final int quantity;

  const OrderConfirmationPage(
      {Key? key, required this.product, required this.quantity})
      : super(key: key);

  @override
  _OrderConfirmationPageState createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  String? _deliveryAddress;
  final _orderFormKey = GlobalKey<FormState>();
  bool isLoading = false;

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid address';
    }
    return null;
  }

  void _createOrder() async {
    setState(() {
      isLoading = true;
    });
    FocusScope.of(context).unfocus();
    if (_orderFormKey.currentState!.validate()) {
      _orderFormKey.currentState!.save();
      Auth auth = Provider.of<Auth>(context, listen: false);
      final navigator = Navigator.of(context);
      try {
        await Server.createOrder(auth.accessToken!,
            productId: widget.product.id,
            deliveryAddress: _deliveryAddress!,
            quantity: widget.quantity,
            businessId: widget.product.ownerID);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SuccessfulPurchasePage(),
          ),
        );
      } on ServerException catch (error) {
        if (error.isAuthException()) {
          auth.delete();
          navigator.popUntil((route) => route.isFirst);
          return;
        }
        if (!mounted) return;
        final snackBar = SnackBar(content: Text(error.message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

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
              child: Column(children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Text("Your purchase",
                        style: Theme.of(context).textTheme.titleLarge)),
                Row(children: [
                  const Icon(Icons.fastfood_outlined),
                  Expanded(
                      child: ListTile(
                          title: Text(
                              "\$" +
                                  (widget.product.price * widget.quantity)
                                      .toStringAsFixed(2),
                              style: Theme.of(context).textTheme.titleLarge))),
                ]),
                const SizedBox(height: 16.0),
                Form(
                    key: _orderFormKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            onSaved: (value) => _deliveryAddress = value,
                            validator: (value) => _validateAddress(value),
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Delivery Address',
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  child: const Text("Confirm Purchase"),
                                  onPressed: () async => _createOrder(),
                                )
                        ])),
              ]),
            ),
            elevation: 8.0,
            margin: const EdgeInsets.all(16.0)),
      ),
    );
  }
}
