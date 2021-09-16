import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ipsb_partner_app/src/models/product.dart';
import 'package:ipsb_partner_app/src/services/api/coupon_service.dart';
import 'package:ipsb_partner_app/src/services/api/product_service.dart';

class DropdownItem {
  final String? value;
  final String? display;

  DropdownItem({
    this.value = '',
    this.display = '',
  });
}

class CouponFieldsName {
  static const String name = 'name';
  static const String description = 'description';
  static const String imageUrl = 'imageUrl';
  static const String storeId = 'storeId';
  static const String code = 'code';
  static const String discountType = 'discountType';
  static const String publishDate = 'publishDate';
  static const String expireDate = 'expireDate';
  static const String amount = 'amount';
  static const String maxDiscount = 'maxDiscount';
  static const String productInclude = 'productInclude';
  static const String productExclude = 'productExclude';
  static const String limit = 'limit';
  static const String status = 'status';
  static const String minSpend = 'minSpend';
}

class CreateCouponController extends GetxController {
  ICouponService _couponService = Get.find();
  IProductService _productService = Get.find();
  ImagePicker _imagePicker = Get.find();
  final formStates = List.generate(3, (index) => GlobalKey<FormState>());

  /// Current step
  final currentStep = 0.obs;

  /// Selected
  final selectedItem = Rx<DropdownItem?>(null);

  /// Products
  final products = listProduct.obs;

  final filePath = ''.obs;

  /// dropdown items
  final dropdownItems = dropdownFinal.obs;

  @override
  void onInit() {
    super.onInit();
    getProducts();
  }

  Future<void> getProducts() async {
    products.value = await _productService.getProductsByStoreId(18);
  }

  /// Move to next step
  void moveToNext() {
    if (validate()) {
      save();
      currentStep.value++;
    }
  }

  /// Back to previous step
  void backToPrevious() {
    save();
    currentStep.value--;
  }

  void gotoStep(int step) {
    if (step < currentStep.value) {
      currentStep.value = step;
    }
    if (!validate()) return;
    currentStep.value = step;
    save();
  }

  final productIncludes = <Product>[].obs;
  final productExcludes = <Product>[].obs;

  bool notExceedStep(step) {
    int current = currentStep.value;
    if (current == 3) return true;
    save();
    if (validate() && current == 2) return true;
    if (validate() && current == 1 && step == 2) return true;
    return false;
  }

  bool validate() {
    return formStates[currentStep.value].currentState?.validate() ?? false;
  }

  void save() {
    formStates[currentStep.value].currentState?.save();
  }

  final couponData = <String, dynamic>{}.obs;

  void inputValue(String key, dynamic value, [dynamic realValue]) {
    if (realValue != null) {
      value = realValue;
    }
    if (couponData.containsKey(key)) {
      couponData[key] = value;
    } else {
      couponData.putIfAbsent(key, () => value);
    }
    print(couponData);
  }

  void inputDropdown(String key, DropdownItem? value) {
    if (value == null) return;
    selectedItem.value = value;
    return inputValue(key, value.value);
  }

  void chooseProducts(String key, List<Product>? value) async {
    if (value == null) return;
    if (key == CouponFieldsName.productInclude) productIncludes.value = value;
    if (key == CouponFieldsName.productExclude) productExcludes.value = value;
    String products = value.map((e) => e.id.toString()).toList().join(',');
    return inputValue(key, products);
  }

  Future<void> getImage() async {
    final picked = await _imagePicker.getImage(source: ImageSource.gallery);
    filePath.value = picked?.path ?? '';
  }

  Image showImage() {
    if (filePath.isNotEmpty) {
      return Image.file(File(filePath.value));
    } else {
      return Image.asset('assets/images/upload_image_icon.png');
    }
  }

  Future<void> submitForm() async {
    validate();
    print(couponData);
    final postValue = <String, dynamic>{};
    postValue.addAll(couponData);
    couponData.keys.forEach((key) {
      switch (key) {
        case CouponFieldsName.amount:
        case CouponFieldsName.minSpend:
        case CouponFieldsName.maxDiscount:
        case CouponFieldsName.limit:
          postValue[key] = int.parse(couponData[key]);
          break;
      }
    });
    postValue.putIfAbsent('storeId', () => 18);
    BotToast.showSimpleNotification(title: "Đang tạo mới!");
    await _couponService.addCoupon(postValue, [filePath.value]);
    Timer(Duration(seconds: 1),
        () => BotToast.showSimpleNotification(title: "Đã tạo thành công!!!"));

    Get.back();
  }
}

List<DropdownItem> dropdownFinal = [
  DropdownItem(value: 'Fixed', display: 'Giảm trực tiếp trên giá tiền'),
  DropdownItem(
      value: 'Percentage', display: 'Giảm giá theo phần trăm đơn hàng'),
];

List<Product> listProduct = [
  Product(
    id: 1,
    name: 'GOLDEN LOTUS TEA',
    description:
        'Thức uống chinh phục những thực khách khó tính! Sự kết hợp độc đáo giữa trà Ô long, hạt sen thơm bùi và củ năng giòn tan. Thêm vào chút sữa sẽ để vị thêm ngọt ngào.',
    price: 39000,
    imageUrl:
        'https://www.highlandscoffee.com.vn/vnt_upload/product/03_2018/TRASENVANG.png',
  ),
  Product(
    id: 2,
    name: 'GOLDEN LOTUS TEA',
    description:
        'Thức uống chinh phục những thực khách khó tính! Sự kết hợp độc đáo giữa trà Ô long, hạt sen thơm bùi và củ năng giòn tan. Thêm vào chút sữa sẽ để vị thêm ngọt ngào.',
    price: 39000,
    imageUrl:
        'https://www.highlandscoffee.com.vn/vnt_upload/product/03_2018/TRASENVANG.png',
  ),
  Product(
    id: 3,
    name: 'GOLDEN LOTUS TEA',
    description:
        'Thức uống chinh phục những thực khách khó tính! Sự kết hợp độc đáo giữa trà Ô long, hạt sen thơm bùi và củ năng giòn tan. Thêm vào chút sữa sẽ để vị thêm ngọt ngào.',
    price: 39000,
    imageUrl:
        'https://www.highlandscoffee.com.vn/vnt_upload/product/03_2018/TRASENVANG.png',
  ),
  Product(
    id: 4,
    name: 'GOLDEN LOTUS TEA',
    description:
        'Thức uống chinh phục những thực khách khó tính! Sự kết hợp độc đáo giữa trà Ô long, hạt sen thơm bùi và củ năng giòn tan. Thêm vào chút sữa sẽ để vị thêm ngọt ngào.',
    price: 39000,
    imageUrl:
        'https://www.highlandscoffee.com.vn/vnt_upload/product/03_2018/TRASENVANG.png',
  ),
];
