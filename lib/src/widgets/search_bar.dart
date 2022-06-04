import 'package:flutter/material.dart';

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
