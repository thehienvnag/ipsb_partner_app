import 'package:ipsb_partner_app/src/common/endpoints.dart';
import 'package:ipsb_partner_app/src/models/account.dart';
import 'package:ipsb_partner_app/src/services/api/base_service.dart';

mixin IAuthService {
  Future<Account?> getAccountByEmail(String email, String password);
}

class AuthService extends BaseService<Account> implements IAuthService {
  @override
  String endpoint() {
    return Endpoints.auth;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return Account.fromJson(json);
  }


  @override
  Future<Account?> getAccountByEmail(String email, String password) {
    return postBase(
      {
        'email': email,
        'password': password,
      },
    );
  }


}
