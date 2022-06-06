import 'package:envios_ya/src/pages/business_home.dart';
import 'package:envios_ya/src/widgets/orders_list.dart';
import 'package:envios_ya/src/pages/business_products.dart';
import 'package:envios_ya/src/observers/page_reloader.dart';
import 'package:envios_ya/src/services/server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import 'new_product.dart';

class BusinessMainPage extends StatefulWidget {
  const BusinessMainPage({Key? key}) : super(key: key);

  @override
  State<BusinessMainPage> createState() => _BusinessMainPageState();
}

class _BusinessMainPageState extends State<BusinessMainPage> {
  int _selectedIndex = 0;
  final PageReloadObserver _reloadObserver = PageReloadObserver();
  late List<Widget> _tabs;

  @override
  void initState() {
    _tabs = [
      const BusinessHome(),
      const OrdersList(onLoad: Server.getBusinessOrders),
      BusinessProducts(reloadObserver: _reloadObserver),
    ];
    super.initState();
  }

  void _addProduct(context) async {
    final addedProduct = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NewProductPage(),
      ),
    );

    if (addedProduct != null && addedProduct) {
      _reloadObserver.notifyListeners();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envios Ya'),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<Auth>(context, listen: false).delete();
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: _tabs.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_rounded),
            label: 'Catalog',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 2
          ? FloatingActionButton(
              onPressed: () => _addProduct(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
