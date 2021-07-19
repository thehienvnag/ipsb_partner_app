import 'package:get/get.dart';
import 'package:indoor_positioning_visitor/src/pages/check_qr_code/bindings/check_qr_code_binding.dart';
import 'package:indoor_positioning_visitor/src/pages/check_qr_code/views/check_qr_code_page.dart';
import 'package:indoor_positioning_visitor/src/pages/create-coupon/bindings/create_coupon_binding.dart';
import 'package:indoor_positioning_visitor/src/pages/create-coupon/views/create_coupon_page.dart';
import 'package:indoor_positioning_visitor/src/pages/manage_coupon/bindings/manage_coupon_binding.dart';
import 'package:indoor_positioning_visitor/src/pages/manage_coupon/views/manage_coupon_page.dart';
import 'package:indoor_positioning_visitor/src/routes/routes.dart';
import 'package:indoor_positioning_visitor/src/pages/home/bindings/home_binding.dart';
import 'package:indoor_positioning_visitor/src/pages/home/views/home_page.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.createCoupon,
      page: () => CreateCouponPage(),
      binding: CreateCouponBinding(),
    ),
    GetPage(
      name: Routes.manageCoupon,
      page: () => ManageCouponPage(),
      binding: ManageCouponBinding(),
    ),
    GetPage(
      name: Routes.checkQRCode,
      page: () => CheckQRCodePage(),
      binding: CheckQRCodeBinding(),
    ),
  ];
}
