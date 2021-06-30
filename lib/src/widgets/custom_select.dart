import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:indoor_positioning_visitor/src/widgets/rounded_button.dart';

class CustomSelect<T> extends StatefulWidget {
  /// Label of select
  final String label;

  /// Data source to show
  final List<T> items;

  /// Background color
  final Color color;

  final bool required;

  /// Item in dropdown builder
  final Widget Function(T item, bool selected, Function(bool) changeSelected)
      itemBuilder;

  /// Item selected builder
  final Widget Function(T item, Function remove) selectedItemBuilder;

  /// on submitted item
  final Function(List<T>? items) onSubmitted;

  final List<T>? selectedItems;

  const CustomSelect({
    Key? key,
    required this.label,
    required this.items,
    this.color = const Color(0xffF9F7F7),
    required this.required,
    required this.selectedItemBuilder,
    required this.onSubmitted,
    this.selectedItems,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  _CustomSelectState<T> createState() => _CustomSelectState<T>();
}

class _CustomSelectState<T> extends State<CustomSelect<T>> {
  /// Selected items
  List<T>? selectedItems;

  final FocusNode _focusNodeText = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.selectedItems != null) {
      selectedItems = [];
      setState(() {
        selectedItems!.addAll(widget.selectedItems!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: widget.color,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 60,
            child: TextFormField(
              focusNode: _focusNodeText,
              onTap: () => showDialog(),
              showCursor: false,
              readOnly: true,
              decoration: InputDecoration(
                labelText: widget.label,
                suffixIcon: Icon(
                  Icons.chevron_right_outlined,
                  size: 34,
                ),
                border: InputBorder.none,
              ),
              validator: widget.required
                  ? (value) => validator(widget.label.toLowerCase())
                  : null,
            ),
          ),
          Container(
            height: determineHeight(selectedItems?.length ?? 0),
            width: 300,
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 10,
              childAspectRatio: determineRatio(selectedItems?.length ?? 0),
              physics: ScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: selectedItems == null
                  ? []
                  : selectedItems!
                      .map((e) => Container(
                          width: 300,
                          child:
                              widget.selectedItemBuilder(e, () => remove(e))))
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  String? validator(String fieldName) {
    if (selectedItems == null) return 'Vui lòng chọn $fieldName';
    return null;
  }

  double determineHeight(int items) {
    if (items == 0) return 10;
    if (items == 1) return 60;
    return 100;
  }

  double determineRatio(int items) {
    if (items == 0) return 1;
    if (items == 1) return 1 / 6;
    return 1 / 4.2;
  }

  void remove(e) {
    setState(() {
      selectedItems?.remove(e);
    });
  }

  Future<void> showDialog() async {
    List<T>? result = await showCupertinoModalBottomSheet(
      context: context,
      topRadius: Radius.circular(30),
      elevation: 100,
      builder: (context) => DialogWidget<T>(
        items: widget.items,
        itemBuilder: widget.itemBuilder,
        selectedItems: selectedItems ?? [],
      ),
    );
    widget.onSubmitted(result);
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      selectedItems = result;
    });
  }
}

class SelectItemWrapper<T> {
  final T value;
  bool selected;

  SelectItemWrapper({
    required this.value,
    this.selected = false,
  });
}

class DialogWidget<T> extends StatefulWidget {
  final List<T> items;
  final List<T> selectedItems;

  /// Item in dropdown builder
  final itemBuilder;
  DialogWidget({
    Key? key,
    required this.items,
    required this.selectedItems,
    required this.itemBuilder,
  }) : super(key: key);
  @override
  _DialogWidgetState<T> createState() => _DialogWidgetState<T>();
}

class _DialogWidgetState<T> extends State<DialogWidget> {
  ///Text field controller
  final TextEditingController _textController = TextEditingController();

  ///Focus node
  final FocusNode _inputNode = FocusNode();

  /// items
  List<SelectItemWrapper<T>> wrapperItems = [];

  @override
  void initState() {
    super.initState();
    widget.itemBuilder.runtimeType;
    wrapperItems = widget.items.map((e) {
      bool selected = widget.selectedItems.contains(e);
      return SelectItemWrapper<T>(value: e, selected: selected);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: RoundedButton(
          radius: 28,
          onPressed: () => _inputNode.requestFocus(),
          color: Colors.transparent,
          icon: Icon(Icons.search, size: 25, color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        middle: Container(
          height: 45,
          margin: const EdgeInsets.only(bottom: 8),
          child: TextFormField(
            controller: _textController,
            focusNode: _inputNode,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
            ),
          ),
        ),
        trailing: RoundedButton(
          radius: 28,
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.close,
            size: 25,
            color: Colors.grey,
          ),
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 25.0, // soften the shadow
            spreadRadius: 5.0, //extend the shadow
            offset: Offset(
              5.0, // Move to right 10  horizontally
              5.0, // Move to bottom 10 Vertically
            ),
          )
        ]),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final item = wrapperItems[index];
                  return GestureDetector(
                    onTap: () => setSelected(wrapperItems, item),
                    child: widget.itemBuilder(
                      item.value,
                      item.selected,
                      (value) => setSelected(wrapperItems, item, value),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                itemCount: wrapperItems.length,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back(
                  result: wrapperItems
                      .where((e) => e.selected)
                      .map((e) => e.value)
                      .toList(),
                );
              },
              child: Text('XÁC NHẬN'),
            ),
          ],
        ),
      ),
    );
  }

  void setSelected(List<SelectItemWrapper<T>> items, SelectItemWrapper<T> item,
      [bool? value]) {
    setState(() {
      if (value != null) {
        item.selected = value;
      } else {
        item.selected = !item.selected;
      }
    });
  }
}
