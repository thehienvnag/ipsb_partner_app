import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/models/account.dart';
import 'package:ipsb_partner_app/src/pages/profile_detail/controllers/profile_detail_controller.dart';
import 'package:ipsb_partner_app/src/services/global_states/auth_services.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';
import 'package:ipsb_partner_app/src/utils/utils.dart';

class ProfileDetailPage extends GetView<ProfileDetailController> {
  final SharedStates sharedData = Get.find();

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    final Account? userInfo = AuthServices.userLoggedIn.value;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back(closeOverlays: true);
          },
        ),
        elevation: 1,
        title: Column(
          children: [
            Text(
              'Update Infomation',
              style: TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Obx(() {
                      String filePath = controller.filePath.value;
                      return Container(
                          height: context.height * 0.13,
                          width: context.width * 0.243,
                          margin: EdgeInsets.only(top: 30),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 10))
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: Utils.resolveFileImg(
                                  filePath,
                                  userInfo!.imageUrl.toString(),
                                ),
                              )));
                    }),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => controller.getImage(),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              color: Colors.green,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 48,
                margin: EdgeInsets.only(top: 60, right: 20, left: 20),
                child: TextFormField(
                  initialValue: userInfo!.name.toString(),
                  onChanged: (value) {
                    controller.changeName(value);
                  },
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.grey.withOpacity(0.6))),
                      hintText: 'Enter your name',
                      hintStyle: TextStyle(color: Colors.black45),
                      prefixIcon: Icon(
                        Icons.person_pin_rounded,
                        color: Colors.grey,
                      )),
                  //controller: phoneController,
                ),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(4)),
              ),
              Container(
                height: 60,
                margin: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextFormField(
                  initialValue: userInfo.email.toString(),
                  enabled: false,
                  onChanged: (value) {
                    controller.changeName(value);
                  },
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.grey.withOpacity(0.6))),
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: Colors.black45),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.grey,
                      )),
                ),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(4)),
              ),
              Container(
                height: 48,
                margin: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextFormField(
                  initialValue: userInfo.phone.toString(),
                  onChanged: (value) {
                    controller.changePhone(value);
                  },
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.grey.withOpacity(0.6))),
                      hintText: 'Enter your phone',
                      hintStyle: TextStyle(color: Colors.black45),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.grey,
                      )),
                ),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              ),
              GestureDetector(
                onTap: () {
                  controller.updateProfile(userInfo.id!);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: context.height * 0.0645,
                  margin: EdgeInsets.only(top: 35, right: 20, left: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 63,
                      vertical: 13,
                    ),
                    child: SizedBox(
                      width: context.width * 0.406,
                      height: context.height * 0.0245,
                      child: Text(
                        "Save",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xff2AD4D3),
                      borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget buildTextField(String labelText, String placeholder) {
  //   return Container(
  //     margin: EdgeInsets.only(left: 20, right: 20),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(4),
  //       // color: Colors.red,
  //     ),
  //     child: Padding(
  //       padding: EdgeInsets.all(10),
  //       child: TextFormField(
  //         initialValue: placeholder,
  //         onChanged: (value) {
  //           // controller.changeName(value);
  //         },
  //         decoration: InputDecoration(
  //             contentPadding: EdgeInsets.only(bottom: 3),
  //             labelText: labelText,
  //             labelStyle: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black),
  //             floatingLabelBehavior: FloatingLabelBehavior.always,
  //             hintStyle: TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.black,
  //             )),
  //       ),
  //     ),
  //   );
  // }
}
