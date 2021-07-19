import 'package:indoor_positioning_visitor/src/common/endpoints.dart';
import 'package:indoor_positioning_visitor/src/models/coupon_in_use.dart';
import 'package:indoor_positioning_visitor/src/models/paging.dart';
import 'package:indoor_positioning_visitor/src/services/api/base_service.dart';

mixin ICouponInUseService {
  Future<Paging<CouponInUse>> getCouponInUseByStoreId(int storeId);
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
    return getPagingBase({
      'storeId': storeId.toString(),
      'status': "Used"
    });
  }
}