import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bullet_list/flutter_bullet_list.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ipsb_partner_app/src/models/coupon.dart';
import 'package:ipsb_partner_app/src/pages/coupon_detail/controllers/coupon_detail_controller.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';
import 'package:ipsb_partner_app/src/utils/formatter.dart';
import 'package:ipsb_partner_app/src/widgets/ticket_box.dart';

class CouponDetailPage extends GetView<CouponDetailController> {
  final dateTime = DateTime.now();
  final SharedStates sharedData = Get.find();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Obx(() {
      final coupon =  sharedData.coupon.value;
      if (coupon.id == null) {
        return Scaffold(
          body: Center(
            child: Text('Loading'),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back(closeOverlays: true);
            },
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          title: Column(
            children: [
              Text(
                'Coupon Details',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(children: [
            SizedBox(height: screenSize.height*0.0258),
            TicketBox(
              xAxisMain: false,
              fromEdgeMain: screenSize.height*0.66,
              fromEdgeSeparator: 134,
              isOvalSeparator: false,
              smallClipRadius: 15,
              clipRadius: 15,
              numberOfSmallClips: 12,
              ticketWidth: screenSize.width*0.9,
              ticketHeight: screenSize.height*0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Card(
                                child: Container(
                                  width: screenSize.width*0.4,
                                  height: screenSize.height*0.2,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(coupon.imageUrl!),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Formatter.shorten(coupon.store?.name).toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: screenSize.width*0.9,
                        child: FlutterBulletList(
                          data: [
                            ListItemModel(
                                label: "Promotions: ",
                                data: [ListItemModel(label: "${coupon.name}")]),
                            ListItemModel(label: "Apply for: ", data: [
                              ListItemModel(
                                  label: "Full menu (does not apply combos) "),
                              ListItemModel(label: "Price does not include VAT"),
                            ]),
                            ListItemModel(
                              label: "Note: ",
                              data: [
                                ListItemModel(
                                  label: "Valid in store only",
                                ),
                                ListItemModel(
                                    label:
                                    "Only 1 code can be applied when paying"),
                                ListItemModel(
                                    label:
                                    "Applies to multiple products in the same bill"),

                              ],
                            ),
                          ],
                          textStyle:
                          TextStyle(color: Colors.black54, fontSize: 16), bulletColor: Colors.grey, bulletSize: 3,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: 8,),
                          GestureDetector(
                              onTap: (){
                                showCustomDialog(context,coupon);
                              },
                              child: Text('View More', style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w700),)),
                          SizedBox(width: 40,),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: screenSize.height*0.2,
                    padding: const EdgeInsets.only(top: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlutterBulletList(
                          textStyle:
                          TextStyle(color: Colors.black54, fontSize: 16),
                          bulletColor: Colors.grey,
                          bulletSize: 3,
                          data: [
                            ListItemModel(
                              label: "Time application: ",
                              data: [
                                ListItemModel(
                                  label:
                                  "[${Formatter.date(coupon.publishDate)}]     ----     [${Formatter.date(coupon.expireDate)}]",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      );
    });
  }
}

void showCustomDialog(BuildContext context,Coupon coupon) => showDialog(
  context: context,
  barrierDismissible: false,
  builder: (BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 12),
            Text('${coupon.name}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            SizedBox(height: 20),
            Container(
              color: Color(0xfffafafa),
              padding: EdgeInsets.only(left: screenSize.width*0.08,bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(width: screenSize.width*0.4,child: Text("Amount limit: ")),
                  Text("${coupon.limit ?? "1000"}")
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: screenSize.width*0.08,bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(width: screenSize.width*0.4,child: Text("Minimum spend: ")),
                  Text("${Formatter.price(coupon.minSpend ?? 50000).toUpperCase()}")
                ],
              ),
            ),
            Container(
              color: Color(0xfffafafa),
              padding: EdgeInsets.only(left: screenSize.width*0.08,bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(width: screenSize.width*0.4,child: Text("Maximum discount: ")),
                  Text("${Formatter.price(coupon.maxDiscount ?? 200000).toUpperCase()}")
                ],
              ),
            ),
            SizedBox(height: 12),
            TextButton(
              child: Text('Close', style: TextStyle(fontSize: 15,)),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
  },
);