import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/models/account.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/services/api/auth_service.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';
import 'package:ipsb_partner_app/src/utils/firebase_helper.dart';

class LoginController extends GetxController {
  // Share states across app
  final SharedStates sharedStates = Get.find();
  Account? account;
  IAuthService _authService = Get.find();

  final loginEmail = ''.obs;
  final loginPassword = ''.obs;

  /// Set value loginEmail
  void setMail(String email) {
    loginEmail.value = email;
  }

  /// Set value loginPassword
  void setPassword(String password) {
    loginPassword.value = password;
  }

  void submitForm() async{

    BotToast.showText(
        text: "In Process !",
        textStyle: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        duration: const Duration(seconds: 7));
    BotToast.showLoading();
    account = await _authService.getAccountByEmail(loginEmail.value, loginPassword.value);
    // code login here

    if (!account.isNull) {
      BotToast.showText(text: "Login successfully", textStyle: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),);
      sharedStates.account = account;
      Get.offAndToNamed(Routes.home);
      print('info ne: ' + account!.email.toString() +" ---- "+ account!.name.toString());
      if (account!.role == 'Store Owner') {
        FirebaseHelper helper = FirebaseHelper();
        await helper.subscribeToTopic("store_id_" + account!.store!.id.toString());
      }
    } else {
      BotToast.showText(
          text: "Email or password not correct !",
          textStyle: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          duration: const Duration(seconds: 5));
      Get.toNamed(Routes.login);
    }
    BotToast.closeAllLoading();
  }
}
