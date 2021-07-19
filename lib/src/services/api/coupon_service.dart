import 'package:indoor_positioning_visitor/src/common/endpoints.dart';
import 'package:indoor_positioning_visitor/src/models/coupon.dart';
import 'package:indoor_positioning_visitor/src/models/paging.dart';
import 'package:indoor_positioning_visitor/src/services/api/base_service.dart';

mixin ICouponService {
  Future<Paging<Coupon>> getCoupons();

  Future<Paging<Coupon>> getCouponsByStoreId(int storeId);

  Future<Coupon?> getCouponById(int id);

  Future<bool> removeCoupon(int couponId);

  Future<List<Coupon>> checkCode(int storeId, int couponId, String code);
}

class CouponService extends BaseService<Coupon> implements ICouponService {
  @override
  String endpoint() {
    return Endpoints.coupons;
  }

  @override
  Coupon fromJson(Map<String, dynamic> json) {
    return Coupon.fromJson(json);
  }

  Future<Paging<Coupon>> getCoupons() async {
    return getPagingBase({});
  }

  @override
  Future<Paging<Coupon>> getCouponsByStoreId(int storeId) {
    return getPagingBase(
      {
        'storeId': storeId.toString(),
        'status': 'Active',
      },
    );
  }

  @override
  Future<Coupon?> getCouponById(int id) {
    return getByIdBase(id);
  }

  @override
  Future<bool> removeCoupon(int couponId) {
    return deleteBase(couponId);
  }

  @override
  Future<List<Coupon>> checkCode(int storeId, int couponId, String code) {
    return getAllBase(
      {
        'id': couponId.toString(),
        'storeId': storeId.toString(),
        'code': code,
      },
    );
  }
}
