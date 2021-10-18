
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';

class HomeController extends GetxController {
  final SharedStates states = Get.find();

  void onpress(int index){
    Get.offAndToNamed(choices[index].route);
    states.bottomBarSelectedIndex.value = index+1;
  }

  @override
  void onInit() {
    super.onInit();
  }
}

class Choice {
  const Choice( {required this.title, required this.icon, required this.color, required this.route});
  final String title;
  final IconData icon;
  final Color color;
  final String route;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Scant QR', icon: Icons.qr_code, color: Color(0xFF4940e2), route: Routes.checkQRCode,),
  const Choice(title: 'Coupons', icon: Icons.local_activity,color: Color(0xFFf98127),route: Routes.manageCoupon),
  const Choice(title: 'Ibeacon', icon: Icons.view_in_ar,color: Color(0xFF38ba78),route: Routes.locatorTag,),
  const Choice(title: 'Profile', icon: Icons.person,color: Color(0xFFf53147),route: Routes.profile,),
];

