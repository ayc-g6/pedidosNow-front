import 'package:envios_ya/src/models/business.dart';
import 'package:envios_ya/src/models/order.dart';
import 'package:envios_ya/src/models/product.dart';
import 'package:envios_ya/src/models/work.dart';
import 'package:envios_ya/src/widgets/order_view.dart';
import 'package:envios_ya/src/widgets/orders_list.dart';
import 'package:envios_ya/src/services/server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';

class DeliveryMainPage extends StatefulWidget {
  const DeliveryMainPage({Key? key}) : super(key: key);

  @override
  State<DeliveryMainPage> createState() => _DeliveryMainPageState();
}

class _DeliveryMainPageState extends State<DeliveryMainPage> {
  Future<Map<String, dynamic>> getWork(
      BuildContext context, int orderId) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Map<String, dynamic> data = {};
    try {
      Map<String, dynamic> orderData = await Server.getOrder(orderId);
      Order order = Order.fromJson(orderData);
      Map<String, dynamic> businessData =
          await Server.getBusiness(order.businessId);
      Business business = Business.fromJson(businessData);
      Map<String, dynamic> productData =
          await Server.getProduct(order.productId);
      Product product = Product.fromJson(productData);
      data['order'] = order;
      data['business'] = business;
      data['product'] = product;
    } on ServerException catch (error) {
      final snackBar = SnackBar(content: Text(error.message));
      scaffoldMessenger.showSnackBar(snackBar);
      rethrow;
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Work>(
      builder: (context, work, child) {
        switch (work.state) {
          case WorkState.uninitialized:
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
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          case WorkState.free:
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
                body: const OrdersList(onLoad: Server.getDeliveryOrders));
          case WorkState.busy:
            return FutureBuilder(
              future: getWork(context, work.workId!),
              builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Envios Ya'),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Provider.of<Auth>(context, listen: false)
                                  .delete();
                            },
                            icon: const Icon(Icons.logout_rounded),
                          ),
                        ],
                      ),
                      body: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  default:
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Scaffold(
                        appBar: AppBar(
                          title: const Text('Envios Ya'),
                          actions: [
                            IconButton(
                              onPressed: () {
                                Provider.of<Auth>(context, listen: false)
                                    .delete();
                              },
                              icon: const Icon(Icons.logout_rounded),
                            ),
                          ],
                        ),
                        body: const Center(
                          child: Text(
                              'Something went wrong! Please log out and sign in again'),
                        ),
                      );
                    }
                    final data = snapshot.data!;
                    return Scaffold(
                      appBar: AppBar(
                        title: Text('Order #${data['order']!.id}'),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Provider.of<Auth>(context, listen: false)
                                  .delete();
                            },
                            icon: const Icon(Icons.logout_rounded),
                          ),
                        ],
                      ),
                      body: RefreshIndicator(
                        onRefresh: () => Future.sync(() => setState(() {})),
                        child: OrderView(
                          product: data['product']!,
                          order: data['order']!,
                          business: data['business']!,
                        ),
                      ),
                    );
                }
              },
            );
        }
      },
    );
  }
}
