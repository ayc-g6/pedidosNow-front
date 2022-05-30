import 'package:envios_ya/src/models/auth.dart';
import 'package:envios_ya/src/services/server.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

// TODO Dummy
class Order {}

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
    try {
      // Auth auth = Provider.of<Auth>(context, listen: false);
      //final newItemsData = await Server.getOrders(accessToken, pageKey);
      final fakeNewItemsData = [1, 2, 3, 4];
      // TODO Use .fromJSON()
      List<Order> newItems = List<Order>.from(fakeNewItemsData.map(
        (e) => Order(),
      ));

      // If not mounted, using page controller throws Error.
      if (!mounted) return;

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
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
