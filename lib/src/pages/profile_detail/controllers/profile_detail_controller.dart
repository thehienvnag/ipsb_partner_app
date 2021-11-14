import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipsb_partner_app/src/models/account.dart';
import 'package:ipsb_partner_app/src/services/api/account_service.dart';
import 'package:ipsb_partner_app/src/services/global_states/auth_services.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';

class ProfileDetailController extends GetxController {
  IAccountService _service = Get.find();
  final SharedStates sharedData = Get.find();
  Account? userInfo;

  final profileName = "".obs;

  void changeName(String content) {
    profileName.value = content;
  }

  final profilePhone = "".obs;

  void changePhone(String content) {
    profilePhone.value = content;
  }

  ImagePicker _imagePicker = Get.find();
  final filePath = ''.obs;

  Future<void> getImage() async {
    filePath.value = '';
    final picked = await _imagePicker.getImage(source: ImageSource.gallery);
    filePath.value = picked?.path ?? '';
  }

  void deleteImage() {
    filePath.value = '';
  }

  void updateProfile(int accountId) async {
    BotToast.showLoading();
    userInfo = AuthServices.userLoggedIn.value;
    if (profilePhone.value.isEmpty) {
      profilePhone.value = userInfo!.phone!;
    }
    if (profileName.value.isEmpty) {
      profileName.value = userInfo!.name!;
    }
    bool updateS = false;
    if (filePath.value.isEmpty) {
      filePath.value = "";
    }
    updateS =
    await _service.updateProfile(accountId, profileName.value, profilePhone.value, filePath.value);
    if (updateS) {
      BotToast.showText(
          text: "Update Success !",
          textStyle: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          duration: const Duration(seconds: 5));
    } else {
      BotToast.showText(
          text: "Update Failed !",
          textStyle: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          duration: const Duration(seconds: 5));
    }
    BotToast.closeAllLoading();
  }
}
