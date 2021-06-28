import 'package:get/get.dart';

import 'package:indoor_positioning_visitor/src/models/coupon.dart';
import 'package:indoor_positioning_visitor/src/models/product.dart';
import 'package:indoor_positioning_visitor/src/pages/create-coupon/views/choose_products.dart';

class DropdownItem {
  final String? value;
  final String? display;

  DropdownItem({
    this.value,
    this.display,
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
  /// Current step
  final currentStep = 1.obs;

  /// Move to next step
  void moveToNext() {
    currentStep.value++;
  }

  /// Back to previous step
  void backToPrevious() {
    currentStep.value--;
  }

  final couponData = {}.obs;

  void inputValue(String key, dynamic value) {
    if (couponData.containsKey(key)) {
      couponData[key] = value;
    } else {
      couponData.putIfAbsent(key, () => value);
    }
  }

  void inputDropdown(String key, DropdownItem? value) {
    if (value == null) return;
    if (couponData.containsKey(key)) {
      couponData[key] = value.value;
    } else {
      couponData.putIfAbsent(key, () => value.value);
    }
  }

  /// Products
  final products = listProduct.obs;

  /// Chosen products
  final chosenProductsInclude = <Product>[].obs;

  final chooseProductExclude = <Product>[].obs;

  void chooseProducts(String type) async {
    Get.to(() => ChooseProducts(type: type));
  }

  void choose(bool? isSelected, Product pro, String type) {
    products.value = products.map((p) {
      if (p.id == pro.id) {
        p.isSelected = isSelected;
      }
      return p;
    }).toList();
    if (type == 'productInclude') {
      chosenProductsInclude.value =
          products.where((p) => p.isSelected!).toList();
      String productInclude =
          chosenProductsInclude.map((e) => e.id).toList().join(',');
      couponData[CouponFieldsName.productInclude] = productInclude;
    }
    if (type == 'productExclude') {
      chooseProductExclude.value =
          products.where((p) => p.isSelected!).toList();
      String productExclude =
          chooseProductExclude.map((e) => e.id).toList().join(',');
      couponData[CouponFieldsName.productExclude] = productExclude;
    }
    print(couponData);
  }

  void clearChosen() {
    chosenProductsInclude.value = [];
  }
}

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
