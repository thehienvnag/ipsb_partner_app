import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indoor_positioning_visitor/src/models/product.dart';
import 'package:indoor_positioning_visitor/src/pages/create-coupon/controllers/create_coupon_controller.dart';

import 'package:indoor_positioning_visitor/src/utils/formatter.dart';
import 'package:indoor_positioning_visitor/src/widgets/custom_select.dart';
import 'package:intl/intl.dart';

class CreateCouponPage extends GetView<CreateCouponController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'TẠO KHUYẾN MÃI',
          style: TextStyle(color: Colors.black87),
        ),
        leading: _buildLeading(),
        actions: [_buildActions()],
        elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            return _buildStep(controller.currentStep.value);
          }),
        ),
      ),
    );
  }

  Widget _buildStep(int stepIndex) {
    switch (stepIndex) {
      case 1:
        return _buildStepGeneral();
      case 2:
        return _buildStepDetails();
      case 3:
        return _buildStepFinal();
      default:
        return _buildStepGeneral();
    }
  }

  Widget _buildStepGeneral() {
    return Column(
      children: [
        Container(
          width: 240,
          height: 140,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Image.asset('assets/images/upload_image_icon.png'),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 25.0, // soften the shadow
                spreadRadius: 5.0, //extend the shadow
                offset: Offset(
                  5.0, // Move to right 10  horizontally
                  5.0, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 45,
                child: TextFormField(
                  onFieldSubmitted: (value) =>
                      controller.inputValue(CouponFieldsName.name, value),
                  decoration: InputDecoration(
                    labelText: 'Tên ưu đãi:',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    filled: true,
                    fillColor: Color(0xffF9F7F7),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 45,
                child: TextFormField(
                  onFieldSubmitted: (value) =>
                      controller.inputValue(CouponFieldsName.code, value),
                  decoration: InputDecoration(
                    labelText: 'Mã khuyến mãi:',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    filled: true,
                    fillColor: Color(0xffF9F7F7),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('TẠO MÃ ƯU ĐÃI NGẪU NHIÊN'),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 47,
                child: DropdownSearch<DropdownItem>(
                  itemAsString: (item) => item.display!,
                  mode: Mode.BOTTOM_SHEET,
                  showSelectedItem: false,
                  items: [
                    DropdownItem(
                        value: 'Fixed',
                        display: 'Giảm trực tiếp trên giá tiền'),
                    DropdownItem(
                        value: 'Percentage',
                        display: 'Giảm giá theo phần trăm đơn hàng'),
                  ],
                  label: "Loại Khuyến mãi",
                  onChanged: (value) => controller.inputDropdown(
                      CouponFieldsName.discountType, value),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 45,
                child: TextFormField(
                  onFieldSubmitted: (value) =>
                      controller.inputValue(CouponFieldsName.amount, value),
                  decoration: InputDecoration(
                    labelText: 'Giá trị khuyến mãi:',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    filled: true,
                    fillColor: Color(0xffF9F7F7),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: TextFormField(
                  onFieldSubmitted: (value) => controller.inputValue(
                      CouponFieldsName.description, value),
                  decoration: InputDecoration(
                    labelText: 'Chi tiết ưu đãi:',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    filled: true,
                    fillColor: Color(0xffF9F7F7),
                  ),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 4,
                  maxLines: 4,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepFinal() {
    return Column(
      children: [
        Container(
          width: 240,
          height: 140,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Image.asset('assets/images/upload_image_icon.png'),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 25.0, // soften the shadow
                spreadRadius: 5.0, //extend the shadow
                offset: Offset(
                  5.0, // Move to right 10  horizontally
                  5.0, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 45,
                child: TextFormField(
                  onFieldSubmitted: (value) =>
                      controller.inputValue(CouponFieldsName.limit, value),
                  decoration: InputDecoration(
                    labelText: 'Giới hạn lượt sử dụng:',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    filled: true,
                    fillColor: Color(0xffF9F7F7),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 47,
                child: Container(
                  height: 45,
                  child: DateTimeField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.calendar_today),
                      labelText: 'Thời gian bắt đầu khuyến mãi:',
                      filled: true,
                      fillColor: Color(0xffF9F7F7),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                    ),
                    format: DateFormat('dd-MM-yyyy hh:mm'),
                    //onChanged: (value) => ,
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now(),
                          ),
                          builder: (context, child) => MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          ),
                        );
                        return DateTimeField.combine(date, time);
                      } else {
                        return currentValue;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 45,
                child: DateTimeField(
                  decoration: InputDecoration(
                    labelText: 'Thời gian hết hạn khuyến mãi:',
                    suffixIcon: Icon(Icons.calendar_today),
                    filled: true,
                    fillColor: Color(0xffF9F7F7),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                  ),
                  format: DateFormat('dd-MM-yyyy hh:mm'),
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now(),
                        ),
                        builder: (context, child) => MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        ),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepDetails() {
    return Column(
      children: [
        Container(
          width: 240,
          height: 140,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Image.asset('assets/images/upload_image_icon.png'),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 25.0, // soften the shadow
                spreadRadius: 5.0, //extend the shadow
                offset: Offset(
                  5.0, // Move to right 10  horizontally
                  5.0, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 45,
                child: TextFormField(
                  onFieldSubmitted: (value) => controller.inputValue(
                      CouponFieldsName.maxDiscount, value),
                  decoration: InputDecoration(
                    labelText: 'Giá trị ưu đãi tối đa:',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    filled: true,
                    fillColor: Color(0xffF9F7F7),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 45,
                child: TextFormField(
                  onFieldSubmitted: (value) =>
                      controller.inputValue(CouponFieldsName.minSpend, value),
                  decoration: InputDecoration(
                    labelText: 'Giá trị đơn hàng tối thiểu:',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    filled: true,
                    fillColor: Color(0xffF9F7F7),
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomSelect<Product>(
                label: 'Chọn sản phẩm áp dụng:',
                items: controller.products,
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
                onSubmitted: (items) => print(items?.length),
              ),
              SizedBox(
                height: 20,
              ),
              CustomSelect<Product>(
                label: 'Chọn sản phẩm không áp dụng:',
                items: controller.products,
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
                onSubmitted: (items) => print(items?.length),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeading() {
    return Obx(() {
      int step = controller.currentStep.value;
      return Container(
        padding: const EdgeInsets.all(12),
        child: ClipOval(
          child: Material(
            color: Colors.grey.shade300,
            // Button color
            child: InkWell(
              splashColor: Colors.blueAccent, // Splash color
              onTap: () {
                if (step == 1)
                  Get.back();
                else
                  controller.backToPrevious();
              },
              child: Icon(
                Icons.chevron_left,
                size: 32,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildActions() {
    return Obx(() {
      int step = controller.currentStep.value;
      if (step == 1 || step == 2) {
        return Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: OutlinedButton(
            onPressed: () {
              controller.moveToNext();
            },
            child: Text('TIẾP TỤC'),
          ),
        );
      }
      return Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: ElevatedButton(
          onPressed: () {},
          child: Text('HOÀN TẤT'),
        ),
      );
    });
  }
}
