import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/services/global_states/auth_services.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';

class CustomBottombarController extends GetxController {
  final SharedStates states = Get.find();

  Future<void> changeSelected(int index) async {
    Get.offAndToNamed(items[index].route);
    states.bottomBarSelectedIndex.value = index;
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   clearResult();
  //   setListBottomItems();
  //   states.bottomBarSelectedIndex.value = 0;
  // }
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
          title: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
          icon: icon,
          selectedColor: color,
        );
}

final SharedStates states = Get.find();
List<BottomItem> getBottomItem() {
  List<BottomItem> result = [];
  result.add(
    BottomItem(
      text: 'Home',
      icon: Icon(Icons.home, size: 22),
      route: Routes.home,
    ),
  );
  if (AuthServices.isInRole('Store Owner')) {
    result.add(BottomItem(
      text: 'QR Code',
      icon: Icon(Icons.qr_code, size: 22),
      route: Routes.checkQRCode,
    ));
  }
  if (AuthServices.isInRole('Store Owner')) {
    result.add(BottomItem(
      text: 'Coupons',
      icon: Icon(Icons.local_activity, size: 22),
      route: Routes.manageCoupon,
    ));
  }
  if (AuthServices.isInRole('Building Manager')) {
    result.add(BottomItem(
      text: 'Locator Tag',
      icon: Icon(Icons.view_in_ar, size: 22),
      route: Routes.locatorTag,
    ));
  }
  if (AuthServices.isInRole('Store Owner')) {
    result.add(
      BottomItem(
        text: 'Notification',
        icon: new Stack(
          children: <Widget>[
            new Icon(Icons.notifications, size: 22),
            // states.unreadNotification.value != 0 ?
            Obx(() {
              if (states.unreadNotification.value != 0) {
                return Positioned(
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
                    child: Text(
                      states.unreadNotification.value.toString(),
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                return SizedBox();
              }
            }),
          ],
        ),
        route: Routes.notifications,
      ),
    );
  }

  result.add(
    BottomItem(
      text: 'Profile',
      icon: Icon(Icons.person, size: 22),
      route: Routes.profile,
    ),
  );
  return result;
}

List<BottomItem> items = [];

void setListBottomItems() {
  items = getBottomItem();
}

void clearBottomItemsResult() {
  items = [];
}

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
