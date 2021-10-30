import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';

class CustomBottombarController extends GetxController {
  final SharedStates states = Get.find();
  Future<void> changeSelected(int index) async {
    Get.offAndToNamed(items[index].route);
    states.bottomBarSelectedIndex.value = index;
  }
}

class BottomItem extends SalomonBottomBarItem {
  final String route;
  final String text;
  final Widget icon;
  final Color color;

  BottomItem({
    required this.route,
    required this.text,
    required this.icon,
    this.color = Colors.blueAccent,
  }) : super(
          title: Text(text),
          icon: icon,
          selectedColor: color,
        );
}
final SharedStates states = Get.find();

final items = [
  BottomItem(
    text: 'Home',
    icon: Icon(Icons.home),
    route: Routes.home,
  ),
  BottomItem(
    text: 'QR Code',
    icon: Icon(Icons.qr_code),
    route: Routes.checkQRCode,
  ),
  BottomItem(
    text: 'Coupons',
    icon: Icon(Icons.local_activity),
    route: Routes.manageCoupon,
  ),
  BottomItem(
    text: 'Locator Tag',
    icon: Icon(Icons.view_in_ar),
    route: Routes.locatorTag,
  ),
  BottomItem(
    text: 'Notification',
    icon: new Stack(
      children: <Widget>[
        new Icon(Icons.notifications),
        // states.unreadNotification.value != 0 ?
        new Positioned(
          right: 0,
          child: new Container(
            padding: EdgeInsets.all(1),
            decoration: new BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 12,
              minHeight: 12,
            ),
            child: new Text(
              states.unreadNotification.value.toString(),
              style: new TextStyle(
                color: Colors.white,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ), // : SizedBox(),
      ],
    ),
    route: Routes.notifications,
  ),
  BottomItem(
    text: 'Profile',
    icon: Icon(Icons.person),
    route: Routes.profile,
  ),
];

class CustomBottombar extends GetView<CustomBottombarController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4.0,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: SalomonBottomBar(
          currentIndex: controller.states.bottomBarSelectedIndex.value,
          onTap: (i) => controller.changeSelected(i),
          items: items,
        ),
      );
    });
  }
}
