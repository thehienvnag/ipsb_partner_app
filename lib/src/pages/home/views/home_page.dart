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
        child: Column(
          children: [
            Text(Formatter.fromPrice(1333332222.4)),
            OutlinedButton(
              onPressed: () {
                controller.remove();
              },
              child: Text('Remove 1'),
            ),
            Obx(() {
              final list = controller.listCoupon;
              return Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => Text(
                    list[index].id.toString(),
                  ),
                  itemCount: list.length,
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
