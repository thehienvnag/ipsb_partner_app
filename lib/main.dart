import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:ipsb_partner_app/src/common/app_init.dart';
import 'package:ipsb_partner_app/src/common/strings.dart';
import 'package:ipsb_partner_app/src/routes/app_pages.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';

void main() {
  AppInit.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Strings.appName,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.login,
      getPages: AppPages.routes,
    );
  }
}
