import 'package:ipsb_partner_app/src/common/endpoints.dart';
import 'package:ipsb_partner_app/src/models/coupon.dart';
import 'package:ipsb_partner_app/src/models/paging.dart';
import 'package:ipsb_partner_app/src/services/api/base_service.dart';

mixin ICouponService {
  Future<Paging<Coupon>> getCoupons();

  Future<Paging<Coupon>> getCouponsByStoreId(int storeId);

  Future<Coupon?> getCouponById(int id);

  Future<bool> removeCoupon(int couponId);
  Future<Coupon?> addCoupon(Map<String, dynamic> coupon, List<String> filePath);

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
  Future<Coupon?> addCoupon(
      Map<String, dynamic> coupon, List<String> filePath) {
    return postWithFilesBase(coupon, filePath);
  }

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
