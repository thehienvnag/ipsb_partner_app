import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:indoor_positioning_visitor/src/data/api_helper.dart';
import 'package:indoor_positioning_visitor/src/services/api/coupon_in_use_service.dart';
import 'package:indoor_positioning_visitor/src/services/api/coupon_service.dart';
import 'package:indoor_positioning_visitor/src/services/api/location_service.dart';
import 'package:indoor_positioning_visitor/src/services/global_states/shared_states.dart';

class AppInit {
  static void init() {
    initMobileAppServices();
    initAlgorithmServices();
    initApiServices();
  }

  /// Init mobile app services
  static void initMobileAppServices() {
    // Get image from file system
    Get.lazyPut<ImagePicker>(() => ImagePicker());
    // Shared states between widget
    Get.lazyPut<SharedStates>(() => SharedStates());
  }

  /// Init algorithms services
  static void initAlgorithmServices() {}

  /// Init api services
  static void initApiServices() {
    // Use for calling api
    Get.lazyPut<IApiHelper>(() => ApiHelper());
    // Calling api at location service
    Get.lazyPut<ILocationService>(() => LocationService());
    // Calling api at coupon endpoint
    Get.lazyPut<ICouponService>(() => CouponService());
    // Calling api at coupon-in-use endpoint
    Get.lazyPut<ICouponInUseService>(() => CouponInUseService());
  }
}
