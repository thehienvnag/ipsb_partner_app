import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/models/coupon_in_use.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/services/api/coupon_in_use_service.dart';
import 'package:ipsb_partner_app/src/services/api/coupon_service.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';
import 'package:ipsb_partner_app/src/utils/formatter.dart';
import 'package:ipsb_partner_app/src/utils/utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ipsb_partner_app/src/models/coupon.dart';

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
  int countCouponInUse = 0;

  ICouponService couponService = Get.find();
  ICouponInUseService couponInUseService = Get.find();

  Future<int> _countCouponInUseByCouponId(int couponId) async {
    return await couponInUseService.countCouponInUseByCouponId({"couponId": couponId.toString(), "status": "Used"});
  }

  /// Create QR view to scan and execute
  void onQRViewCreated(BuildContext context, QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isScanned) {
        isScanned = false;
        String tmp = scanData.code;
        List<String> arr = tmp.split(',');
        storeId = int.parse(arr[0]);
        couponId = int.parse(arr[1]);
        couponInUseId = int.parse(arr[2]);
        codeDisplayed = arr[3];
        coupon = await checkCode(storeId!, couponId!, codeDisplayed);

        if (coupon != null) {
          couponInUse = await getCouponInUse(couponInUseId!);

          countCouponInUse = await _countCouponInUseByCouponId(couponId!);
          if (countCouponInUse >= coupon!.limit!) {
            title = "ERROR";
            codeDisplayed = "Unable to apply coupon due to the number of people using the code exceeding the limit.";
            isSuccess = false;
            _buildPopUp(context, title, codeDisplayed, isSuccess, coupon!);
            return;
          }
          if (couponInUse != null) {
            if (couponInUse?.status == "Used") {
              title = "ERROR";
              codeDisplayed = "Coupon cannot be applied because it has already been used.";
              isSuccess = false;
            } else if (couponInUse?.status == "Deleted") {
              codeDisplayed = "Coupon cannot be applied due to out of date.";
              isSuccess = false;
            } else {
              updateCoupon = await putCouponInUse(couponInUseId!, couponId!, 9, "Used");
              if (updateCoupon) {
                title = "VALID COUPON";
                codeDisplayed = 'Name: ' +
                    coupon!.name! +
                    '\n' +
                    'Code: ' +
                    coupon!.code! +
                    '\n' +
                    'Description: ' +
                    coupon!.description! +
                    '\n' +
                    'Publish Date: ' +
                    Utils.date(coupon!.publishDate!) +
                    '\n' +
                    'Expired Date: ' +
                    Utils.date(coupon!.expireDate!);
                isSuccess = true;
              } else {
                title = "ERROR";
                codeDisplayed = "Coupon cannot be used due to error while applying process.";
                isSuccess = false;
              }
            }
          }
        } else {
          title = "ERROR";
          codeDisplayed = "Invalid coupon.";
          isSuccess = false;
        }
        _buildPopUp(context, title, codeDisplayed, isSuccess, coupon!);
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

  Future<void> _buildPopUp(BuildContext context, String title, String code, bool isSuccess, Coupon coupon) {
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
    );

    return popup.show(
      title: titleContainer,
      content: codeContainer,
      actions: [
        !isSuccess
            ? popup.button(
                label: 'Close',
                onPressed: () {
                  Navigator.of(context).pop();
                  isScanned = true;
                })
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        isScanned = true;
                      },
                      child: Text(
                        'Close',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () {showCouponDetailDialog(context, coupon);},
                    child: Text('View Detail'),
                  )
                ],
              )
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

  SharedStates states = Get.find();
  void backToHome() {
    states.bottomBarSelectedIndex.value = 0;
    Get.offNamed(Routes.home);
  }

  void showCustomDialog(BuildContext context) => showDialog(
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
              Container(
                alignment: Alignment.center,
                width: screenSize.width * 0.7,
                color: Color(0xfffafafa),
                child: Text(
                  'ERROR WHILE SAVING COUPON',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: Text(
                  "Unable to save coupon due to the number of people using the code exceeding the limit ",
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 12),
              TextButton(
                child: Text('Close',
                    style: TextStyle(
                      fontSize: 15,
                    )),
                onPressed: () => Get.back(),
              )
            ],
          ),
        ),
      );
    },
  );

  void showCouponDetailDialog(BuildContext context,Coupon coupon) => showDialog(
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
                    Container(width: screenSize.width*0.4,child: Text("Limit: ")),
                    Text("${coupon.limit ?? "N/A"}")
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: screenSize.width*0.08,bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(width: screenSize.width*0.4,child: Text("Minimum spend: ")),
                    Text("${Formatter.price(coupon.minSpend ?? 0).toUpperCase()}")
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
                    Text("${Formatter.price(coupon.maxDiscount ?? 0).toUpperCase()}")
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
}
