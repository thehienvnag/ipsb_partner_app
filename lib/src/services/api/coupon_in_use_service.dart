import 'package:ipsb_partner_app/src/common/endpoints.dart';
import 'package:ipsb_partner_app/src/models/coupon_in_use.dart';
import 'package:ipsb_partner_app/src/models/paging.dart';
import 'package:ipsb_partner_app/src/services/api/base_service.dart';

mixin ICouponInUseService {
  Future<Paging<CouponInUse>> getCouponInUseByStoreId(int storeId);

  Future<CouponInUse?> getCouponInUse(int couponInUseId);

  Future<Paging<CouponInUse>> getCouponInUseByCouponId(int couponId);

  Future<bool> putCoupon(int couponInUseId, String status);

  Future<bool> putReplyFeedbackCouponInUse(int couponInUseId, String content);

  Future<int> countCouponInUseByCouponId(Map<String, dynamic> data);
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
    return getPagingBase(
      {'storeId': storeId.toString(), 'status': "Used"},
    );
  }

  Future<CouponInUse?> getCouponInUse(int couponInUseId) {
    return getByIdBase(couponInUseId);
  }

  @override
  Future<bool> putCoupon(int couponInUseId, String status) {
    return putBase(couponInUseId, {
      'status': status,
    });
  }

  @override
  Future<bool> putReplyFeedbackCouponInUse(int couponInUseId, String content) {
    return putWithOneFileBase({
      'feedbackReply': content,
    }, "", couponInUseId);
  }

  @override
  Future<Paging<CouponInUse>> getCouponInUseByCouponId(int couponId) {
    return getPagingBase(
      {'couponId': couponId.toString(), 'status': "Used"},
    );
  }

  @override
  Future<int> countCouponInUseByCouponId(Map<String, dynamic> data) {
    return countBase(data);
  }
}
