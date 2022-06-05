import 'package:envios_ya/src/models/auth.dart';
import 'package:envios_ya/src/models/business.dart';
import 'package:envios_ya/src/models/order.dart';
import 'package:envios_ya/src/models/product.dart';
import 'package:envios_ya/src/pages/order_view.dart';
import 'package:envios_ya/src/services/server.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class BusinessOrders extends StatefulWidget {
  const BusinessOrders({Key? key}) : super(key: key);

  @override
  State<BusinessOrders> createState() => _BusinessOrdersState();
}

class _BusinessOrdersState extends State<BusinessOrders> {
  final int _pageSize = 5;
  final PagingController<int, Order> _pagingController =
      PagingController(firstPageKey: 0);
  final Map<int, Product> _products = {};
  final Map<String, Business> _businesses = {};

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    Auth auth = Provider.of<Auth>(context, listen: false);
    final navigator = Navigator.of(context);
    try {
      final newItemsData =
          await Server.getBusinessOrders(auth.accessToken!, pageKey);
      print(newItemsData);
      List<Order> newItems =
          List<Order>.of(newItemsData.map((e) => Order.fromJson(e)));
      for (final order in newItems) {
        if (!_products.containsKey(order.productId)) {
          final productData = await Server.getProduct(order.productId);
          _products[order.productId] = Product.fromJson(productData);
        }
        if (!_businesses.containsKey(order.businessId)) {
          final businessData = await Server.getBusiness(order.businessId);
          _businesses[order.businessId] = Business.fromJson(businessData);
        }
      }

      // If not mounted, using page controller throws Error.
      if (!mounted) return;

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey++;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } on ServerException catch (error) {
      if (error.isAuthException()) {
        auth.delete();
        navigator.popUntil((route) => route.isFirst);
      }
    } on Exception catch (error) {
      String errorMessage = error.toString();
      // Show snackbar only if planned error
      if (errorMessage.startsWith('Exception: ')) {
        // Keep only part past 'Exception: '. Yes, it's ugly.
        final snackBar =
            SnackBar(content: Text(error.toString().substring(11)));

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      if (!mounted) return;
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView<int, Order>(
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Order>(
          itemBuilder: (context, item, index) => OrderCard(
            order: item,
            product: _products[item.productId]!,
            business: _businesses[item.businessId]!,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  final Product product;
  final Business business;

  const OrderCard(
      {Key? key,
      required this.order,
      required this.product,
      required this.business})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderViewPage(
              product: product,
              order: order,
              business: business,
            ),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.id}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text('Awaiting Confirmation',
                      style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
              const SizedBox(height: 8.0),
              const Divider(),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${order.quantity} x ${product.name}',
                      style: Theme.of(context).textTheme.labelLarge),
                  Text(
                      '\$ ${(order.quantity * product.price).toStringAsFixed(2)}'),
                ],
              ),
              const SizedBox(height: 8.0),
              const Divider(),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:', style: Theme.of(context).textTheme.labelLarge),
                  Text(
                    '\$ ${(order.quantity * product.price).toStringAsFixed(2)}',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Colors.green),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
