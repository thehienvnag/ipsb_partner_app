import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ipsb_partner_app/src/models/coupon.dart';
import 'package:ipsb_partner_app/src/pages/manage_coupon/controllers/manage_coupon_controller.dart';
import 'package:ipsb_partner_app/src/pages/manage_coupon/views/slidable_widget.dart';
import 'package:ipsb_partner_app/src/widgets/custom_bottom_bar.dart';
import 'package:loading_animations/loading_animations.dart';

class ManageCouponPage extends GetView<ManageCouponController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(
                Icons.add_circle_outline_outlined,
                color: Colors.black,
                size: 35,
              ),
              onPressed: () => controller.createCoupon(),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'DANH SÁCH KHUYẾN MÃI',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Obx(() {
        final coupons = controller.listCoupon;
        if (coupons.isEmpty) {
          return LoadingFlipping.circle(
            borderColor: Colors.cyan,
            borderSize: 3.0,
            size: 30.0,
            backgroundColor: Colors.cyanAccent,
            duration: Duration(milliseconds: 500),
          );
        } else {
          return _buildCoupons(coupons);
        }
      }),
      bottomNavigationBar: CustomBottombar(),
    );
  }
}

Widget _buildCoupons(List<Coupon> coupons) {
  return Container(
    margin: const EdgeInsets.only(top: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 25.0, // soften the shadow
          spreadRadius: 5.0, //extend the shadow
          offset: Offset(
            5.0, // Move to right 10  horizontally
            5.0, // Move to bottom 10 Vertically
          ),
        )
      ],
    ),
    child: ListView.separated(
      itemCount: coupons.length,
      itemBuilder: (context, index) {
        final coupon = coupons[index];
        return SlidableWidget(
          couponId: coupon.id!,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(coupon.imageUrl ?? ''),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10, left: 10),
                        width: 240,
                        child: Text(coupon.name ?? '',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5, left: 10),
                        width: 240,
                        child: Text(
                          coupon.description ?? '',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.info),
                        label: Text('Xem chi tiết'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
        indent: 30,
        endIndent: 30,
        color: Colors.black,
      ),
    ),
  );
}
