import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:indoor_positioning_visitor/src/data/api_helper.dart';
import 'package:indoor_positioning_visitor/src/services/api/account_service.dart';
import 'package:indoor_positioning_visitor/src/services/api/coupon_in_use_service.dart';
import 'package:indoor_positioning_visitor/src/services/api/coupon_service.dart';
import 'package:indoor_positioning_visitor/src/services/api/location_service.dart';
import 'package:indoor_positioning_visitor/src/services/api/product_service.dart';
import 'package:indoor_positioning_visitor/src/services/global_states/shared_states.dart';
import 'package:indoor_positioning_visitor/src/widgets/custom_bottom_bar.dart';

class AppInit {
  static void init() {
    initMobileAppServices();
    initAlgorithmServices();
    initApiServices();
  }

  /// Init mobile app services
  static void initMobileAppServices() {
    // Get image from file system
    Get.lazyPut<ImagePicker>(() => ImagePicker(), fenix: true);
    // Shared states between widget
    Get.lazyPut<SharedStates>(() => SharedStates(), fenix: true);
    // Bottom bar
    Get.lazyPut<CustomBottombarController>(
      () => CustomBottombarController(),
      fenix: true,
    );
  }

  /// Init algorithms services
  static void initAlgorithmServices() {}

  /// Init api services
  static void initApiServices() {
    // Use for calling api
    Get.lazyPut<IApiHelper>(() => ApiHelper(), fenix: true);
    // Calling api at location service
    Get.lazyPut<ILocationService>(() => LocationService(), fenix: true);
    // Calling api at coupon enpoint
    Get.lazyPut<ICouponService>(() => CouponService(), fenix: true);
    // Calling api at product service
    Get.lazyPut<IProductService>(() => ProductService(), fenix: true);
    // Calling api at account enpoint
    Get.lazyPut<IAccountService>(() => AccountService(), fenix: true);
    // Calling api at couponInUse service
    Get.lazyPut<ICouponInUseService>(() => CouponInUseService(), fenix: true);
  }
}
