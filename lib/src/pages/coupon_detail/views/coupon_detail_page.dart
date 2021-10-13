import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bullet_list/flutter_bullet_list.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
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
                'Chi tiết mã giảm giá',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(children: [
            SizedBox(height: 20),
            TicketBox(
              xAxisMain: false,
              fromEdgeMain: 470,
              fromEdgeSeparator: 134,
              isOvalSeparator: false,
              smallClipRadius: 15,
              clipRadius: 15,
              numberOfSmallClips: 8,
              ticketWidth: screenSize.width*0.9,
              ticketHeight: screenSize.height*0.83,
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
                              margin: const EdgeInsets.only(right: 20),
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
                                    fontSize: 16,
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
                                label: "Chương trình: ",
                                data: [ListItemModel(label: "${coupon.name}")]),
                            ListItemModel(label: "Áp dụng cho: ", data: [
                              ListItemModel(
                                  label: "Toàn menu (không áp dụng combo)"),
                              ListItemModel(label: "Giá chưa bao gồm VAT}"),
                            ]),
                            ListItemModel(
                              label: "Lưu ý: ",
                              data: [
                                ListItemModel(
                                  label: "Chỉ áp dụng tại cửa hàng",
                                ),
                                ListItemModel(
                                    label:
                                    "Khi thanh toán chỉ áp dụng duy nhất 1 mã"),
                                ListItemModel(
                                    label:
                                    "Áp dụng cho nhiều sản phẩm trong cùng hóa đơn"),
                              ],
                            ),
                          ],
                          textStyle:
                          TextStyle(color: Colors.black54, fontSize: 16), bulletColor: Colors.grey, bulletSize: 3,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: screenSize.height*0.2,
                    padding: const EdgeInsets.only(bottom: 15),
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
                              label: "Thời gian áp dụng: ",
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