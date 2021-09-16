import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:ipsb_partner_app/src/pages/create-coupon/controllers/create_coupon_controller.dart';

class DiscountTypeDropdown extends StatelessWidget {
  final List<DropdownItem> items;
  final Function(DropdownItem?, String) onChanged;
  final DropdownItem? selectedItem;
  final String fieldName;
  final String label;
  const DiscountTypeDropdown({
    Key? key,
    required this.items,
    required this.onChanged,
    this.selectedItem,
    required this.fieldName,
    required this.label,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF9F7F7),
      child: DropdownSearch<DropdownItem>(
        itemAsString: (item) => item.display!,
        mode: Mode.BOTTOM_SHEET,
        showSelectedItem: false,
        items: items,
        label: label,
        onChanged: (value) => onChanged(value, fieldName),
        selectedItem: selectedItem,
        validator: (value) {
          if (value == null) {
            return 'Vui lòng chọn ${label.toLowerCase()}';
          }
          return null;
        },
      ),
    );
  }
}
