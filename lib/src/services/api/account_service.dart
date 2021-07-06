import 'package:indoor_positioning_visitor/src/common/endpoints.dart';
import 'package:indoor_positioning_visitor/src/models/account.dart';
import 'package:indoor_positioning_visitor/src/services/api/base_service.dart';

mixin IAccountService {
  Future<Account?> getAccountById(int id);
}
class AccountService extends BaseService<Account> implements IAccountService {
  @override
  String endpoint() {
    return Endpoints.accounts;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return Account.fromJson(json);
  }

  @override
  Future<Account?> getAccountById(int id) {
    return getByIdBase(id);
  }

}