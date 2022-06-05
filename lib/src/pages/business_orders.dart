import 'package:envios_ya/src/models/auth.dart';
import 'package:envios_ya/src/models/order.dart';
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
      List<Order> newItems =
          List<Order>.of(newItemsData.map((e) => Order.fromJson(e)));

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
            itemBuilder: (context, item, index) => Text('order $index')),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
