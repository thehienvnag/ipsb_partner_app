import 'package:get/get.dart';
import 'package:indoor_positioning_visitor/src/models/coupon_in_use.dart';
import 'package:indoor_positioning_visitor/src/services/api/coupon_in_use_service.dart';
import 'package:indoor_positioning_visitor/src/services/global_states/shared_states.dart';


class ManageFeedbackController extends GetxController {
  ICouponInUseService _service = Get.find();

  /// Shared data
  final SharedStates sharedData = Get.find();

  /// Get list all coupon of visitor feedback before
  final listCouponInUse = <CouponInUse>[].obs;

  /// Set list coupon of visitor feedback before
  Future<void> getCouponInUse() async {
    final paging = await _service.getCouponInUseByStoreId(15);
    listCouponInUse.value = paging.content!;
  }

  @override
  void onInit() {
    super.onInit();
    getCouponInUse();
  }
}
