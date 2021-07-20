import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:get/get.dart';
import 'package:indoor_positioning_visitor/src/models/coupon_in_use.dart';
import 'package:indoor_positioning_visitor/src/services/api/coupon_in_use_service.dart';
import 'package:indoor_positioning_visitor/src/services/api/coupon_service.dart';
import 'package:indoor_positioning_visitor/src/utils/utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:indoor_positioning_visitor/src/models/coupon.dart';

class CheckQRCodeController extends GetxController {
  // Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final currentStep = 1.obs;

  String title = "";
  Coupon? coupon;
  CouponInUse? couponInUse;
  bool isScanned = true;
  bool isSuccess = true;
  bool updateCoupon = false;
  int? storeId;
  int? couponId;
  int? couponInUseId;
  String codeDisplayed = "";

  ICouponService couponService = Get.find();
  ICouponInUseService couponInUseService = Get.find();

  /// Create QR view to scan and execute
  void onQRViewCreated(BuildContext context, QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isScanned) {
        isScanned = false;
        String tmp  = scanData.code;
        List<String> arr = tmp.split(',');
        storeId = int.parse(arr[0]);
        couponId = int.parse(arr[1]);
        couponInUseId = int.parse(arr[2]);
        codeDisplayed = arr[3];
        coupon = await checkCode(storeId!, couponId!, codeDisplayed);

        if (coupon != null) {
          couponInUse = await getCouponInUse(couponInUseId!);
          if (couponInUse != null) {
            if (couponInUse?.status == "Used") {
              title = "LỖI";
              codeDisplayed =
              "Không thể áp dụng mã giảm giá. Mã giảm giá đã được sử dụng.";
              isSuccess = false;
            } else if (couponInUse?.status == "Deleted") {
              codeDisplayed =
              "Không thể áp dụng mã giảm giá. Mã giảm giá đã hết hạn sử dụng.";
              isSuccess = false;
            } else {
              updateCoupon = await putCouponInUse(couponInUseId!, couponId!, 9, "Used");
              if (updateCoupon) {
                title = "MÃ HỢP LỆ";
                codeDisplayed = 'Tên: ' +
                    coupon!.name! +
                    '\n' +
                    'Mã: ' +
                    coupon!.code! +
                    '\n' +
                    'Mô tả: ' +
                    coupon!.description! +
                    '\n' +
                    'Ngày áp dụng: ' +
                    Utils.date(coupon!.publishDate!)
                    +
                    '\n' +
                    'Ngày hết hạn: ' +
                    Utils.date(coupon!.expireDate!);
                isSuccess = true;
              } else {
                title = "LỖI";
                codeDisplayed =
                "Không thể áp dụng mã giảm giá. Đã xảy ra lỗi trong quá trình áp dụng.";
                isSuccess = false;
              }
            }
          }
        } else {
          title = "LỖI";
          codeDisplayed =
              "Không thể áp dụng mã giảm giá. Mã giảm giá không hợp lệ.";
          isSuccess = false;
        }
        _buildPopUp(context, title, codeDisplayed, isSuccess);
      }
    });
  }

  /// Move to next step
  void moveToNext() {
    if (currentStep.value == 1) {
      currentStep.value++;
    }
  }

  /// Back to previous step
  void backToPrevious() {
    if (currentStep.value == 2) {
      currentStep.value--;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _buildPopUp(
      BuildContext context, String title, String code, bool isSuccess) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final popup = BeautifulPopup(
      context: context,
      template: isSuccess ? TemplateSuccess : TemplateFail,
    );
    final titleContainer = Container(
      width: width,
      child: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );

    final codeContainer = Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: Text(
        code,
        style: TextStyle(color: Colors.black, fontSize: 16),
        textAlign: TextAlign.center,
      ),
      // child: Column(
      //   children: [
      //
      //   ],
      // ),
    );

    return popup.show(
      title: titleContainer,
      content: codeContainer,
      actions: [
        !isSuccess ?
        popup.button(
            label: 'Đóng',
            onPressed: () {
              Navigator.of(context).pop();
              isScanned = true;
            }) :
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    isScanned = true;
                  },
                  child: Text(
                    'Đóng',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  )),
              SizedBox(width: 10,),
              OutlinedButton(
                onPressed: () {},
                child: Text('Xem chi tiết'),
              )
            ],)

      ],
      // bool barrierDismissible = false,
      // Widget close,
    );
  }

  Future<Coupon?> getCouponById(int id) async {
    return await couponService.getCouponById(id);
  }

  Future<Coupon?> checkCode(int storeId, int couponId, String code) async {
    List<Coupon> couponList = await couponService.checkCode(storeId, couponId, code);
    if (couponList.isNotEmpty) {
      return couponList.first;
    }
  }

  Future<CouponInUse?> getCouponInUse(int couponInUseId) async {
    return await couponInUseService.getCouponInUse(couponInUseId);
  }

  Future<bool> putCouponInUse(int couponInUseId, int couponId, int visitorId, String status) async {
    return await couponInUseService.putCoupon(couponInUseId, couponId, visitorId, status);
  }
}
