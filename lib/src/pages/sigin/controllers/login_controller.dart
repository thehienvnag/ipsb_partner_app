import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/models/account.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/services/api/account_service.dart';
import 'package:ipsb_partner_app/src/services/global_states/auth_services.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';
import 'package:ipsb_partner_app/src/utils/firebase_helper.dart';

class LoginController extends GetxController {
  // Share states across app
  final SharedStates sharedStates = Get.find();
  Account? account;
  IAccountService _accountService = Get.find();

  final loginEmail = ''.obs;
  final loginPassword = ''.obs;

  // void initAuth() async {
  //   await AuthServices.initUserFromPrevLogin();
  //   if (AuthServices.isLoggedIn()) {
  //     Get.offAndToNamed(Routes.home);
  //   }
  // }

  /// Set value loginEmail
  void setMail(String email) {
    loginEmail.value = email;
  }

  /// Set value loginPassword
  void setPassword(String password) {
    loginPassword.value = password;
  }

  void submitForm() async {
    BotToast.showText(
      text: "In Process !",
      textStyle: TextStyle(
          fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      duration: const Duration(seconds: 7),
    );
    BotToast.showLoading();
    account = await _accountService.getAccountByEmail(
      loginEmail.value,
      loginPassword.value,
    );
    // code login here

    if (account != null) {
      BotToast.showText(
        text: "Login successfully",
        textStyle: TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      );
      AuthServices.saveAuthInfo(account);
      Get.offAndToNamed(Routes.home);
      if (account!.role == 'Store Owner') {
        FirebaseHelper helper = FirebaseHelper();
        await helper
            .subscribeToTopic("store_id_" + account!.store!.id.toString());
      }
    } else {
      BotToast.showText(
          text: "Email or password not correct !",
          textStyle: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          duration: const Duration(seconds: 5));
    }
    BotToast.closeAllLoading();
  }
}
