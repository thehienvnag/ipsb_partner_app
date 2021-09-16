import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/pages/check_qr_code/bindings/check_qr_code_binding.dart';
import 'package:ipsb_partner_app/src/pages/check_qr_code/views/check_qr_code_page.dart';
import 'package:ipsb_partner_app/src/pages/create-coupon/bindings/create_coupon_binding.dart';
import 'package:ipsb_partner_app/src/pages/create-coupon/views/create_coupon_page.dart';
import 'package:ipsb_partner_app/src/pages/manage_coupon/bindings/manage_coupon_binding.dart';
import 'package:ipsb_partner_app/src/pages/manage_coupon/views/manage_coupon_page.dart';
import 'package:ipsb_partner_app/src/pages/manage_feedback/bindings/manage_feedback_binding.dart';
import 'package:ipsb_partner_app/src/pages/manage_feedback/views/manage_feedback_page.dart';
import 'package:ipsb_partner_app/src/pages/manage_locator_tag/bindings/manage_locator_tag_binding.dart';
import 'package:ipsb_partner_app/src/pages/manage_locator_tag/views/manage_locator_tag_detail_page.dart';
import 'package:ipsb_partner_app/src/pages/manage_locator_tag/views/manage_locator_tag_page.dart';
import 'package:ipsb_partner_app/src/pages/profile/bindings/profile_binding.dart';
import 'package:ipsb_partner_app/src/pages/profile/views/profile_page.dart';
import 'package:ipsb_partner_app/src/pages/profile_detail/bindings/profile_detail_binding.dart';
import 'package:ipsb_partner_app/src/pages/profile_detail/views/profile_detail_page.dart';
import 'package:ipsb_partner_app/src/pages/setting/bindings/setting_binding.dart';
import 'package:ipsb_partner_app/src/pages/setting/views/setting_page.dart';
import 'package:ipsb_partner_app/src/pages/sigin/bindings/login_binding.dart';
import 'package:ipsb_partner_app/src/pages/sigin/views/login_page.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/pages/home/bindings/home_binding.dart';
import 'package:ipsb_partner_app/src/pages/home/views/home_page.dart';

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
    GetPage(
      name: Routes.profile,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.profileDetail,
      page: () => ProfileDetailPage(),
      binding: ProfileDetailBinding(),
    ),
    GetPage(
      name: Routes.setting,
      page: () => SettingPage(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: Routes.feedbacks,
      page: () => ManageFeedbackPage(),
      binding: ManageFeedbackBinding(),
    ),
    GetPage(
      name: Routes.locatorTag,
      page: () => ManageLocatorTagPage(),
      binding: ManageLocatorTagBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.locatorTagDetail,
      page: () => ManageLocatorTagDetailPage(),
      binding: ManageLocatorTagBinding(),
    ),
  ];
}
