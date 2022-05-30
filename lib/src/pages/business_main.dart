import 'package:envios_ya/src/pages/business_home.dart';
import 'package:envios_ya/src/pages/business_orders.dart';
import 'package:envios_ya/src/pages/business_products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';

class BusinessMainPage extends StatefulWidget {
  const BusinessMainPage({Key? key}) : super(key: key);

  @override
  State<BusinessMainPage> createState() => _BusinessMainPageState();
}

class _BusinessMainPageState extends State<BusinessMainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _tabs = [
    BusinessHome(),
    BusinessOrders(),
    BusinessProducts(),
  ];

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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
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
    );
  }
}