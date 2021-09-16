import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:indoor_positioning_visitor/src/models/account.dart';
import 'package:indoor_positioning_visitor/src/routes/routes.dart';
import 'package:indoor_positioning_visitor/src/services/global_states/shared_states.dart';


class LoginController extends GetxController {

  // Share states across app
  final SharedStates sharedStates = Get.find();
  Account? account;

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

  void submitForm(){
    BotToast.showText(text: "In Process !", textStyle: TextStyle(fontSize: 16),
        duration: const Duration(seconds: 7));

    // code login here
    if(account!.email!.isNotEmpty){
      BotToast.showText(text: "Login successfully");
      sharedStates.account = account;
      Get.toNamed(Routes.home);
    }else{
      BotToast.showText(text: "Email or password not correct !", textStyle: TextStyle(fontSize: 16),
          duration: const Duration(seconds: 7));
      Get.toNamed(Routes.login);
    }
  }
}
