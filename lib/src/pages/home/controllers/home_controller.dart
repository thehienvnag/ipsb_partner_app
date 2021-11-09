import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/common/constants.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/services/api/notification_service.dart';
import 'package:ipsb_partner_app/src/services/global_states/auth_services.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';
import 'package:ipsb_partner_app/src/widgets/custom_bottom_bar.dart';

class HomeController extends GetxController {
  final SharedStates states = Get.find();
  INotificationService _service = Get.find();
  List<Choice> choices = <Choice>[].obs;

  void onpress(int index) {
    Get.offAndToNamed(choices[index].route);
    states.bottomBarSelectedIndex.value = index + 1;
  }

  void updateNotifications() async {
    states.unreadNotification.value = await _service.countNotification({
      "status": Constants.unread,
      "accountId": AuthServices.userLoggedIn.value.id.toString()
    });
  }

  void setListChoices() {
    choices = getChoice();
  }

  void clearResult() {
    choices = [];
  }

  @override
  void onInit() {
    super.onInit();
    clearResult();
    setListChoices();
    clearBottomItemsResult();
    setListBottomItems();
    states.bottomBarSelectedIndex.value = 0;
    updateNotifications();
  }
}

List<Choice> getChoice() {
  List<Choice> result = [];
  if (AuthServices.isInRole('Store Owner')) {
    result.add(
      Choice(
        title: 'Scan QR',
        icon: Icons.qr_code,
        color: Color(0xFF4940e2),
        route: Routes.checkQRCode,
      ),
    );
  }
  if (AuthServices.isInRole('Store Owner')) {
    result.add(Choice(
        title: 'Coupons',
        icon: Icons.local_activity,
        color: Color(0xFFf98127),
        route: Routes.manageCoupon));
  }
  if (AuthServices.isInRole('Store Owner')) {
    result.add(Choice(
        title: 'Notification',
        icon: Icons.notifications,
        color: Color(0xFF38ba78),
        route: Routes.notifications));
  }
  if (AuthServices.isInRole('Building Manager')) {
    result.add(Choice(
      title: 'iBeacon',
      icon: Icons.view_in_ar,
      color: Color(0xFF38ba78),
      route: Routes.locatorTag,
    ));
  }
  result.add(
    Choice(
      title: 'Profile',
      icon: Icons.person,
      color: Color(0xFFf53147),
      route: Routes.profile,
    ),
  );
  return result;
}

class Choice {
  const Choice(
      {required this.title,
      required this.icon,
      required this.color,
      required this.route});
  final String title;
  final IconData icon;
  final Color color;
  final String route;
}

// const List<Choice> choices = const <Choice>[
//   const Choice(title: 'Scan QR', icon: Icons.qr_code, color: Color(0xFF4940e2), route: Routes.checkQRCode,),
//   const Choice(title: 'Coupons', icon: Icons.local_activity,color: Color(0xFFf98127),route: Routes.manageCoupon),
//   const Choice(title: 'Ibeacon', icon: Icons.view_in_ar,color: Color(0xFF38ba78),route: Routes.locatorTag,),
//   const Choice(title: 'Profile', icon: Icons.person,color: Color(0xFFf53147),route: Routes.profile,),
// ];

