import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/pages/home/controllers/home_controller.dart';
import 'package:ipsb_partner_app/src/utils/formatter.dart';
import 'package:ipsb_partner_app/src/widgets/custom_bottom_bar.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Home',
          style: TextStyle(color: Colors.black38),
        ),
        elevation: 4,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [],
        ),
      ),
      bottomNavigationBar: CustomBottombar(),
    );
  }
}
