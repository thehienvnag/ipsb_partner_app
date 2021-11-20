import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/common/constants.dart';
import 'package:ipsb_partner_app/src/pages/notifications/controllers/notifications_controller.dart';
import 'package:ipsb_partner_app/src/services/global_states/auth_services.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';
import 'package:ipsb_partner_app/src/utils/utils.dart';
import 'package:ipsb_partner_app/src/widgets/custom_bottom_bar.dart';
import 'package:ipsb_partner_app/src/models/notification.dart';

class NotificationsPage extends GetView<NotificationsController> {
  final SharedStates states = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Notification',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      bottomNavigationBar: CustomBottombar(),
      body: Container(
        child: listNotification(context),
      ),
    );
  }

  Widget listNotification(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Obx(() {
      if (!AuthServices.isLoggedIn()) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 40, right: 20),
                height: screenSize.width * 0.48,
                width: screenSize.width * 0.48,
                child: Image.asset(ConstImg.empty),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  'Notification is not available',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.red,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                width: screenSize.width * 0.77778,
                child: Text(
                  'Come back to check after login in your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      final list = controller.notifications;
      if (controller.loading.value) {
        return Center(child: CircularProgressIndicator());
      }
      if (list.isEmpty) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 40),
                height: screenSize.width * 0.48,
                width: screenSize.width * 0.48,
                child: Image.asset(ConstImg.empty),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  'Notification is empty',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.red,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                width: screenSize.width * 0.77778,
                child: Text(
                  'Come back to check after receiving new notification',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        // separatorBuilder: (context, index) => Divider(
        //   height: 10,
        //   thickness: 0.8,
        //   color: Colors.grey,
        //   indent: 10,
        //   endIndent: 12,
        // ),
        itemBuilder: (context, index) {
          return notificationItem(list[index], context);
        },
        itemCount: list.length,
      );
    });
  }

  Widget notificationItem(Notifications element, BuildContext context) {
    List<String> parameter = [];
    if (element.parameter != null) {
      parameter = element.parameter!.split(":");
    }
    return GestureDetector(
      onTap: () => {
        controller.updateNotifications(element.id!, Constants.read),
        Get.toNamed(
          element.screen!,
          parameters: {
            parameter.first: parameter.last,
          },
        )
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 10,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5),
              height: context.width * 0.25,
              width: context.width * 0.25,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    // 'https://raw.githubusercontent.com/thehienvnag/beauty-at-home-mobile/main/public/img/notification.PNG'),
                    // 'https://ibb.co/DfHrstZ'
                    element.imageUrl != null
                        ? element.imageUrl!
                        : 'https://ibb.co/DfHrstZ',
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              width: context.width * 0.6,
              height: context.height * 0.15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    element.title!,
                    style: TextStyle(fontSize: 15,
                    fontWeight: FontWeight.w500),
                  ),
                  Text(element.body!),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Utils.parseDateTimeToDate(element.date!),
                        style: TextStyle(fontSize: 12),
                      ),
                      element.status == 'Unread'
                          ? Image.asset(
                              ConstImg.newNotification,
                              width: MediaQuery.of(context).size.width * 0.17,
                              height: MediaQuery.of(context).size.width * 0.1,
                            )
                          : SizedBox(),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
