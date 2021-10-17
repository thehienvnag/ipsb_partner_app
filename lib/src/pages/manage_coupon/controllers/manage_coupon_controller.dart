import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/models/coupon.dart';
import 'package:ipsb_partner_app/src/models/coupon_in_use.dart';
import 'package:ipsb_partner_app/src/models/paging.dart';
import 'package:ipsb_partner_app/src/models/store.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/services/api/coupon_in_use_service.dart';
import 'package:ipsb_partner_app/src/services/api/coupon_service.dart';
import 'package:ipsb_partner_app/src/services/api/store_service.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';

class ManageCouponController extends GetxController {

  /// Shared data
  final SharedStates sharedData = Get.find();
  ICouponService couponService = Get.find();
  ICouponInUseService _service = Get.find();
  IStoreService _storeService = Get.find();

  // void gotoFeedbackListDetails(Coupon coupon) {
  //   sharedData.couponDetail.value = coupon;
  //   Get.toNamed(Routes.feedbacks);
  // }


  final listCoupon = <Coupon>[].obs;
  Future<void> getCouponsByStoreId() async {
    Paging<Coupon> paging = await couponService.getCouponsByStoreId(sharedData.account!.store!.id!);
    listCoupon.value = paging.content ?? [];
  }

  bool updateCoupon = false;

  Store? store;
  Future<Store?> getStoreById(int storeId) async {
    return await _storeService.getStoreById(storeId);
  }

  final couponIdHasNewFeedback = "".obs;

  Future<void> getNewFeedback(int couponId) async {
    final paging = await _service.getCouponInUseByCouponId(couponId);
    List<CouponInUse> list = paging.content ?? [];
    for(int i = 0; i < list.length; i++){
      if(list[i].feedbackReply == null){
        couponIdHasNewFeedback.value = couponId.toString();
      }
    }
  }

  void gotoCouponDetails(Coupon coupon) {
    sharedData.coupon.value = coupon;
    Get.toNamed(Routes.couponDetails);
  }

  @override
  void onInit() {
    super.onInit();
    getCouponsByStoreId();
  }
}
