import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipsb_partner_app/src/data/api_helper.dart';
import 'package:ipsb_partner_app/src/services/api/account_service.dart';
import 'package:ipsb_partner_app/src/services/api/coupon_in_use_service.dart';
import 'package:ipsb_partner_app/src/services/api/coupon_service.dart';
import 'package:ipsb_partner_app/src/services/api/location_service.dart';
import 'package:ipsb_partner_app/src/services/api/locator_tag_service.dart';
import 'package:ipsb_partner_app/src/services/api/notification_service.dart';
import 'package:ipsb_partner_app/src/services/api/product_service.dart';
import 'package:ipsb_partner_app/src/services/api/store_service.dart';
import 'package:ipsb_partner_app/src/services/global_states/auth_services.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';
import 'package:ipsb_partner_app/src/utils/firebase_helper.dart';
import 'package:ipsb_partner_app/src/widgets/custom_bottom_bar.dart';

class AppInit {
  static void init() {
    initMobileAppServices();
    initApiServices();
    initializePushNotification();
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
    // Calling api at locatorTag service
    Get.lazyPut<ILocatorTagService>(() => LocatorTagService(), fenix: true);
    // Calling api at store service
    Get.lazyPut<IStoreService>(() => StoreService(), fenix: true);
    // Calling api at ShoppingItem service
    Get.lazyPut<INotificationService>(() => NotificationService(), fenix: true);
  }

  static void initializePushNotification() {
    FirebaseHelper helper = FirebaseHelper();
    helper.requestingPermissionForIOS();
    // helper.getToken();
    helper.initPushNotification();
    helper.setupInteractedMessage();
  }
}
