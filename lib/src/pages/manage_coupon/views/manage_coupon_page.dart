import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ipsb_partner_app/src/models/coupon.dart';
import 'package:ipsb_partner_app/src/pages/manage_coupon/controllers/manage_coupon_controller.dart';
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
          return _buildCoupons(coupons,context,controller);
        }
      }),
      bottomNavigationBar: CustomBottombar(),
    );
  }
}

Widget _buildCoupons(List<Coupon> coupons,BuildContext context,ManageCouponController controller) {
  final screenSize = MediaQuery.of(context).size;
  return Container(
    margin: const EdgeInsets.only(top: 15),
    child: ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: coupons.length,
      itemBuilder: (context, index) {
        final coupon = coupons[index];
        return GestureDetector(
          onTap: () => controller.gotoFeedbackListDetails(coupon),
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
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10, left: 10),
                        width: screenSize.width * 0.5,
                        child: Text(coupon.name ?? '',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5, left: 10),
                        width: screenSize.width * 0.5,
                        child: Text(
                          coupon.description ?? '',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          controller.gotoCouponDetails(coupon);
                        },
                        icon: Icon(Icons.info),
                        label: Text('View Detail'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
