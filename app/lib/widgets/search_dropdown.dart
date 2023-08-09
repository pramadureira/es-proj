import 'package:flutter/material.dart';

class SearchDropdown extends StatefulWidget {
  final String selectedItem;
  final List<String> items;
  final Function(String)? onChanged;
  _SearchDropdownState state = _SearchDropdownState();

  SearchDropdown({
    Key? key,
    required this.selectedItem,
    required this.items,
    this.onChanged,
  }) : super(key: key);

  @override
  _SearchDropdownState createState() {
    state = _SearchDropdownState();
  return state;}

  filterItems_(String query) {
    return items.where((item) => item.toLowerCase().contains(query.trim().toLowerCase())).toList();
  }
}

class _SearchDropdownState extends State<SearchDropdown> {
  late TextEditingController _controller;
  List<String> filteredItems_ = [];
  late final List<String> items;
  double _boxHeight = 0;
  FocusNode inputFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.selectedItem;
    filteredItems_ = widget.items;
    items = widget.items;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void filterItems_(String query) {
    setState(() {
      filteredItems_ = widget.filterItems_(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(

              )
            )
          ),
          child: TextField(
            controller: _controller,
            focusNode: inputFocus,
            onChanged: filterItems_,
            decoration: const InputDecoration(
              hintText: ' what are you looking for',
              border: InputBorder.none,
              isDense: true
            ),
            onTap: () {
              inputFocus.requestFocus();
              setState(() {
                _boxHeight = 200;
              });
            },
            onTapOutside: (tap) {
              if (inputFocus.hasFocus){
                inputFocus.unfocus();
                setState(() {
                  _boxHeight = 0;
                });
                if (!filteredItems_.contains(_controller.text) && _controller.text != '') {
                    _controller.text = widget.selectedItem;
                }
                if (widget.onChanged != null) {
                  widget.onChanged!(_controller.text);
                }
              }
            },
            onEditingComplete: () {
              inputFocus.unfocus();
              setState(() {
                _boxHeight = 0;
              });
              if (!filteredItems_.contains(_controller.text) && _controller.text != '') {
                _controller.text = widget.selectedItem;
              }
              if (widget.onChanged != null) {
                widget.onChanged!(_controller.text);
              }
            },
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: SizedBox(
            key: Key('dropdown list tags'),
            height: _boxHeight,
            child: TextFieldTapRegion(
              child: ListView.builder(
                itemCount: filteredItems_.length,
                itemBuilder: (context, index) {
                  final item = filteredItems_[index];
                  return InkWell(
                    onTap: () {
                      if (widget.onChanged != null) {
                        widget.onChanged!(item);
                      }

                      inputFocus.unfocus();

                      setState(() {
                        _boxHeight = 0;
                        _controller.text = item;
                        _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: Text(item),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
