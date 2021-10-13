import 'package:ipsb_partner_app/src/common/endpoints.dart';
import 'package:ipsb_partner_app/src/models/store.dart';
import 'package:ipsb_partner_app/src/services/api/base_service.dart';

mixin IStoreService {
  Future<Store?> getStoreById(int storeId);
}

class StoreService extends BaseService<Store> implements IStoreService {

  @override
  String endpoint() {
    return Endpoints.stores;
  }

  @override
  Store fromJson(Map<String, dynamic> json) {
    return Store.fromJson(json);
  }

  @override
  Future<Store?> getStoreById(int storeId) {
    return getByIdBase(storeId);
  }
}
