import 'package:envios_ya/src/models/auth.dart';
import 'package:envios_ya/src/models/business.dart';
import 'package:envios_ya/src/services/server.dart';
import 'package:envios_ya/src/observers/page_reloader.dart';
import 'package:envios_ya/src/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';

class ProductList extends StatefulWidget {
  final Future<List<Product>> Function(int index) loadProducts;
  final PageReloadObserver? pageReloadObserver;

  const ProductList(
      {Key? key, required this.loadProducts, this.pageReloadObserver})
      : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final nameSearched = "";
  final int _pageSize = 5;
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 0);
  final Map<String, Business> _businesses = {};

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    widget.pageReloadObserver?.addListener(() {
      _pagingController.refresh();
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    Auth auth = Provider.of<Auth>(context, listen: false);
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      List<Product> newProducts = await widget.loadProducts(pageKey);
      for (final product in newProducts) {
        if (!_businesses.containsKey(product.ownerID)) {
          final businessData = await Server.getBusiness(product.ownerID);
          _businesses[product.ownerID] = Business.fromJson(businessData);
        }
      }

      // If not mounted, using page controller throws Error.
      if (!mounted) return;

      final isLastPage = newProducts.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newProducts);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newProducts, nextPageKey);
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
        scaffoldMessenger.showSnackBar(snackBar);
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
      child: PagedListView<int, Product>(
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Product>(
          itemBuilder: (context, item, index) => ProductCard(
            product: item,
            business: _businesses[item.ownerID]!,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.pageReloadObserver?.clearListeners();
    _pagingController.dispose();
    super.dispose();
  }
}
