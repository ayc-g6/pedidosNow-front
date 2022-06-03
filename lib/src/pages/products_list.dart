import 'package:envios_ya/src/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/product.dart';

class ProductListPage extends StatefulWidget {
  final bool includesSearching;
  final Future<List<Product>> Function(int index, [String? name]) loadProducts;

  const ProductListPage(
      {Key? key, required this.includesSearching, required this.loadProducts})
      : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String _nameSearched = "";
  final int _pageSize = 5;
  final PagingController<int, Product> _pagingController =
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
      final newItems = await widget.loadProducts(pageKey, _nameSearched);

      // If not mounted, using page controller throws Error.
      if (!mounted) return;

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
      child: Column(
        children: [
          SearchBar(
            search: widget.includesSearching,
            onSubmitted: (value) {
              setState(() {
                _nameSearched = value;
              });
              if (!mounted) return;
              _pagingController.refresh();
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.sync(
                () => _pagingController.refresh(),
              ),
              child: PagedListView<int, Product>(
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Product>(
                  itemBuilder: (context, item, index) => Card(
                    child: ProductCard(product: item),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

class SearchBar extends StatefulWidget {
  final bool search;
  final void Function(String)? onSubmitted;

  const SearchBar({Key? key, required this.search, this.onSubmitted})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(color: Colors.black);
    final styleHint = TextStyle(color: Colors.black54);
    final style = _textController.text.isEmpty ? styleHint : styleActive;

    return widget.search
        ? Container(
            height: 42,
            margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              border: Border.all(color: Colors.black26),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: TextField(
              controller: _textController,
              autofocus: false,
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: style.color),
                suffixIcon: _textController.text.isNotEmpty
                    ? GestureDetector(
                        child: Icon(Icons.close, color: style.color),
                        onTap: () {
                          _textController.clear();
                          widget.onSubmitted?.call(_textController.text);
                        },
                      )
                    : null,
                hintText: "Enter the product's name",
                hintStyle: style,
                border: InputBorder.none,
              ),
              style: style,
              onSubmitted: (value) {
                widget.onSubmitted?.call(value);
              },
            ),
          )
        : Container();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
