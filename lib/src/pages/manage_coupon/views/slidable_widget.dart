import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'package:ipsb_partner_app/src/pages/manage_coupon/controllers/manage_coupon_controller.dart';

class SlidableWidget<T> extends GetView<ManageCouponController> {
  final Widget child;
  final int couponId;
  const SlidableWidget({
    Key? key,
    required this.child,
    required this.couponId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Slidable(
        actionPane: SlidableDrawerActionPane(),
        child: child,
        secondaryActions: [
          IconSlideAction(
            caption: 'Update',
            color: Colors.black45,
            icon: Icons.settings,
            onTap: () {},
          ),
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    actions: [
                      OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('Hủy'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.removeCoupon(couponId);
                        },
                        child: Text('Xác nhận'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      );
}
