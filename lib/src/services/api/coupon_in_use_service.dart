import 'package:indoor_positioning_visitor/src/common/endpoints.dart';
import 'package:indoor_positioning_visitor/src/models/coupon_in_use.dart';
import 'package:indoor_positioning_visitor/src/services/api/base_service.dart';

mixin ICouponInUseService {
  Future<CouponInUse?> getCouponInUse(int couponInUseId);

  Future<bool> putCoupon(int couponInUseId, int couponId, int visitorId, String status);
}

class CouponInUseService extends BaseService<CouponInUse> implements ICouponInUseService {
  @override
  String endpoint() {
    return Endpoints.couponInUses;
  }

  @override
  CouponInUse fromJson(Map<String, dynamic> json) {
    return CouponInUse.fromJson(json);
  }

  @override
  Future<CouponInUse?> getCouponInUse(int couponInUseId) {
    return getByIdBase(couponInUseId);
  }

  @override
  Future<bool> putCoupon(int couponInUseId, int couponId, int visitorId, String status) {
    DateTime applyDate = DateTime.now();
    return putBase(couponInUseId, {
      'id' : couponInUseId,
      'couponId' : couponId,
      'visitorId' : visitorId,
      'applyDate' : applyDate.toString(),
      'status' : status,
    });
  }


}