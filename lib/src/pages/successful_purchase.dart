import 'package:flutter/material.dart';

class SuccessfulPurchasePage extends StatelessWidget {
  const SuccessfulPurchasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Envios Ya"),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.task_alt_rounded, size: 176.0),
            const SizedBox(height: 32.0),
            Text("Your order is now being prepared!",
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 32.0),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text("Return to main menu"))
          ],
        )));
  }
}
