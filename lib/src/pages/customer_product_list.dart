import 'package:envios_ya/src/models/product.dart';
import 'package:envios_ya/src/pages/customer_orders.dart';
import 'package:envios_ya/src/widgets/products_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../services/server.dart';

class MySearchDelegate extends SearchDelegate {
  final List<String> _suggestions = [
    'Salad',
    'Chicken',
    'French Fries',
    'Burger',
    'Pizza',
    'Empanada',
    'Beer',
    'Water',
    'Juice',
    'Soda',
    'Ice Cream',
    'Flan',
    'Brownie',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
        icon: const Icon(Icons.clear_rounded),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, query);
      },
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ProductList(
      loadProducts: (index) async {
        String? accessToken =
            Provider.of<Auth>(context, listen: false).accessToken;
        // We allow exceptions to propagate to the caller Widget
        final productsData = await Server.getProducts(index, query);
        List<Product> products =
            List.of(productsData.map((e) => Product.fromJson(e)));
        return products;
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchingSuggestions = _suggestions.where((element) {
      return element.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: matchingSuggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            matchingSuggestions.elementAt(index),
          ),
          onTap: () {
            query = matchingSuggestions.elementAt(index);
            showResults(context);
          },
        );
      },
    );
  }
}

class CustomerProductList extends StatelessWidget {
  const CustomerProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envios Ya'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(),
              );
            },
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: ProductList(
        loadProducts: (index) async {
          String? accessToken =
              Provider.of<Auth>(context, listen: false).accessToken;
          // We allow exceptions to propagate to the caller Widget
          final productsData = await Server.getProducts(index);
          List<Product> products =
              List.of(productsData.map((e) => Product.fromJson(e)));
          return products;
        },
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    child: Image(
                      image: AssetImage('images/enviosya_logo.png'),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.list_rounded),
                    title: const Text('My Orders'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerOrdersPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_rounded),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Provider.of<Auth>(context, listen: false).delete();
              },
              leading: Icon(Icons.logout_rounded, color: Colors.red[700]),
              title: Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.red[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
