import 'package:flutter/material.dart';

import 'package:ipsb_partner_app/src/models/product.dart';
import 'package:ipsb_partner_app/src/utils/formatter.dart';
import 'package:ipsb_partner_app/src/widgets/custom_select.dart';

class SelectProduct extends StatelessWidget {
  final String label;
  final List<Product> items;
  final Function(List<Product>?) onSubmitted;
  final List<Product>? selectedProducts;
  final bool required;
  const SelectProduct({
    Key? key,
    required this.label,
    required this.items,
    required this.onSubmitted,
    this.required = false,
    this.selectedProducts,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomSelect<Product>(
      label: label,
      items: items,
      itemBuilder: (item, selected, changeSelected) => ListTile(
        leading: Image.network(item.imageUrl!),
        title: Text(Formatter.shorten(item.name)),
        subtitle: Text(Formatter.shorten(item.description)),
        trailing: Checkbox(
          value: selected,
          onChanged: (value) => changeSelected(value!),
        ),
      ),
      selectedItemBuilder: (item, remove) => Chip(
        avatar: Image.network(item.imageUrl!),
        label: Text(item.name!),
        deleteIcon: Icon(Icons.close),
        onDeleted: () => remove(),
      ),
      onSubmitted: onSubmitted,
      required: required,
      selectedItems: selectedProducts,
    );
  }
}
