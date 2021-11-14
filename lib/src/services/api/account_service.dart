import 'package:ipsb_partner_app/src/common/endpoints.dart';
import 'package:ipsb_partner_app/src/models/account.dart';
import 'package:ipsb_partner_app/src/services/api/base_service.dart';

mixin IAccountService {
  Future<Account?> getAccountById(int id);
  Future<Account?> getAccountByEmail(String email, String password);
  Future<bool> updateProfile(int accountId, String name, String phone, String filePath);
  Future<Account?> refreshToken(String refreshToken);
  Future<Account?> getById(int id);
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

  @override
  Future<Account?> getAccountByEmail(String email, String password) {
    return postPure(Endpoints.login, {
      "email": email,
      "password": password,
    });
  }

  @override
  Future<bool> updateProfile(int accountId, String name, String phone, String filePath) {
    return putWithOneFileBase(
        {"name": name, "phone": phone, "firstUpdateProfile" : true.toString()}, filePath, accountId);
  }

  @override
  Future<Account?> refreshToken(String refreshToken) {
    return postNoAuth(Endpoints.refreshToken, {"refreshToken": refreshToken});
  }

  @override
  Future<Account?> getById(int id) {
    return getByIdBase(id);
  }
}
