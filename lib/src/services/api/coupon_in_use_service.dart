import 'package:ipsb_partner_app/src/common/endpoints.dart';
import 'package:ipsb_partner_app/src/models/coupon_in_use.dart';
import 'package:ipsb_partner_app/src/models/paging.dart';
import 'package:ipsb_partner_app/src/services/api/base_service.dart';

mixin ICouponInUseService {
  Future<Paging<CouponInUse>> getCouponInUseByStoreId(int storeId);
  Future<CouponInUse?> getCouponInUse(int couponInUseId);

  Future<bool> putCoupon(
      int couponInUseId, int couponId, int visitorId, String status);
}

class CouponInUseService extends BaseService<CouponInUse>
    implements ICouponInUseService {
  @override
  String endpoint() {
    return Endpoints.couponsInUse;
  }

  @override
  CouponInUse fromJson(Map<String, dynamic> json) {
    return CouponInUse.fromJson(json);
  }

  @override
  Future<Paging<CouponInUse>> getCouponInUseByStoreId(int storeId) {
    return getPagingBase({'storeId': storeId.toString(), 'status': "Used"});
  }

  Future<CouponInUse?> getCouponInUse(int couponInUseId) {
    return getByIdBase(couponInUseId);
  }

  @override
  Future<bool> putCoupon(
      int couponInUseId, int couponId, int visitorId, String status) {
    DateTime applyDate = DateTime.now();
    return putWithOneFileBase({
      'id': couponInUseId,
      'couponId': couponId,
      'visitorId': visitorId,
      'applyDate': applyDate.toString(),
      'status': status,
    }, "", couponInUseId);
  }
}
