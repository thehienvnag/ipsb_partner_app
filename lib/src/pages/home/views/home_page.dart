import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:indoor_positioning_visitor/src/pages/home/controllers/home_controller.dart';
import 'package:indoor_positioning_visitor/src/utils/formatter.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text(Formatter.fromPrice(1333332222.4)),
      ),
    );
  }
}
