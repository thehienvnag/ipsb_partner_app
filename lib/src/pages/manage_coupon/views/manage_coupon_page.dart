import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ipsb_partner_app/src/models/coupon.dart';
import 'package:ipsb_partner_app/src/pages/manage_coupon/controllers/manage_coupon_controller.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/utils/formatter.dart';
import 'package:ipsb_partner_app/src/widgets/custom_bottom_bar.dart';
import 'package:loading_animations/loading_animations.dart';

class ManageCouponPage extends GetView<ManageCouponController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Coupon list',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Obx(() {
        final coupons = controller.listCoupon;
        if (coupons.isEmpty) {
          return Center(
            child: LoadingBouncingLine.circle(
              borderColor: Colors.cyan,
              borderSize: 3.0,
              size: 30.0,
              backgroundColor: Colors.cyanAccent,
              duration: Duration(milliseconds: 500),
            ),
          );
        } else {
          return _buildCoupons(coupons, context, controller);
        }
      }),
      bottomNavigationBar: CustomBottombar(),
    );
  }
}

Widget _buildCoupons(List<Coupon> coupons, BuildContext context,
    ManageCouponController controller) {
  final screenSize = MediaQuery.of(context).size;
  return Container(
    margin: const EdgeInsets.only(top: 15),
    child: ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: coupons.length,
      itemBuilder: (context, index) {
        final coupon = coupons[index];
        controller.getNewFeedback(coupon.id!.toInt());
        return GestureDetector(
          onTap: () => Get.toNamed(
            Routes.feedbacks,
            parameters: {
              "couponId": coupon.id.toString(),
            },
          ),
          child: Card(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  height: screenSize.width * 0.2,
                  width: screenSize.width * 0.2,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(coupon.imageUrl ?? ''),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10, left: 5),
                        width: screenSize.width * 0.35,
                        child: Text(coupon.name ?? '',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5, left: 5),
                        width: screenSize.width * 0.35,
                        child: Text(
                          Formatter.shorten(coupon.description, 20),
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          controller.gotoCouponDetails(coupon);
                        },
                        icon: Icon(
                          Icons.info,
                          size: 16,
                        ),
                        label: Text('View Detail', style: TextStyle(fontSize: 12),),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  String couponIdHasFB =
                      controller.couponIdHasNewFeedback.value;
                  String couponId = coupon.id.toString();
                  return (couponIdHasFB.compareTo(couponId) == 0)
                      ? Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Get.toNamed(
                                  Routes.feedbacks,
                                  parameters: {
                                    "couponId": coupon.id.toString(),
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.add_alert,
                                size: 18,
                                color: Colors.orangeAccent,
                              ),
                              label: Text('New feedbacks', style: TextStyle(fontSize: 12),),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Get.toNamed(
                                  Routes.feedbacks,
                                  parameters: {
                                    "couponId": coupon.id.toString(),
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.add_chart,
                                size: 18,
                                color: Colors.black,
                              ),
                              label: Text('View Feedback', style: TextStyle(fontSize: 12),),
                            ),
                          ],
                        );
                }),
              ],
            ),
          ),
        );
      },
    ),
  );
}
