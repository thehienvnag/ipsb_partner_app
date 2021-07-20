import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:get/get.dart';
import 'package:indoor_positioning_visitor/src/models/coupon.dart';
import 'package:indoor_positioning_visitor/src/routes/routes.dart';
import 'package:indoor_positioning_visitor/src/widgets/animated_button_bar.dart';

import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:indoor_positioning_visitor/src/pages/check_qr_code/controllers/check_qr_code_controller.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CheckQRCodePage extends GetView<CheckQRCodeController> {
  Coupon? coupon;
  String title = "";
  String code = "";
  String content = "";
  bool isSuccess = true;
  int? storeId;
  int? couponId;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            return _buildStep(controller.currentStep.value, context);
          }),
          Obx(() {
            return Align(
                alignment: Alignment.topCenter,
                child: _buildTitle(controller.currentStep.value, context));
          }),
          Obx(() {
            return _buildIcon(controller.currentStep.value, context);
          }),
          Obx(() {
            return Positioned(
              child: controller.currentStep.value == 2
                  ? Center(child: _buildInputField(context))
                  : Container(),
              top: height * 0.385,
              left: width * 0.09,
            );
          }),
        ],
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.125,
        child: AnimatedButtonBar(
          radius: 16.0,
          innerRadius: 8.0,
          padding: const EdgeInsets.all(16.0),
          backgroundColor: Colors.grey.shade400,
          foregroundColor: Colors.white,
          elevation: 4,
          invertedSelection: true,
          children: [
            ButtonBarEntry(
                onTap: () {
                  // ignore: unnecessary_statements
                  controller.backToPrevious();
                  // // ignore: unnecessary_statements
                  // controller.resumeCamera();
                },
                child: Text('Quét mã',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16))),
            ButtonBarEntry(
                onTap: () {
                  // ignore: unnecessary_statements
                  controller.moveToNext();
                  // // ignore: unnecessary_statements
                  // controller.pauseCamera();
                  controller.dispose();
                },
                child: Text(
                  'Nhập mã',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                )),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildIcon(int stepIndex, BuildContext context) {
    switch (stepIndex) {
      case 1:
        return _buildQRIcon(context);
      case 2:
        return _buildEnterIcon(context);
      default:
        return _buildQRIcon(context);
    }
  }

  Widget _buildStep(int stepIndex, BuildContext context) {
    switch (stepIndex) {
      case 1:
        return _buildQrView(context);
      case 2:
        return _buildEnterCodeView(context);
      default:
        return _buildQrView(context);
    }
  }

  Widget _buildTitle(int stepIndex, BuildContext context) {
    switch (stepIndex) {
      case 1:
        return _buildQRTitle(context);
      case 2:
        return _buildEnterTitle(context);
      default:
        return _buildQRTitle(context);
    }
  }

  Widget _buildQRIcon(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Positioned(
      child: IconButton(
        icon: Icon(
          Icons.cancel,
          size: width * 0.1,
          color: Colors.white,
        ),
        onPressed: () {
          controller.backToHome();
        },
      ),
      top: height * 0.065,
      left: width * 0.025,
    );
  }

  Widget _buildEnterIcon(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Positioned(
      child: IconButton(
        icon: Icon(
          Icons.cancel,
          size: width * 0.1,
          color: Colors.black,
        ),
        onPressed: () {},
      ),
      top: height * 0.065,
      left: width * 0.025,
    );
  }

  Widget _buildQRTitle(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.65,
      height: height * 0.16,
      margin: EdgeInsets.only(top: 150),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Quét mã QR',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Text('Quét mã QR từ các mã giảm giá bạn đã lưu',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildEnterTitle(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.85,
      height: height * 0.16,
      margin: EdgeInsets.only(top: 150),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Nhập mã giảm giá',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          Text('Nhập mã giảm giá từ các mã bạn đã lưu hoặc quét mã QR',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 230.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
        key: controller.qrKey,
        // onQRViewCreated: controller.onQRViewCreated,
        onQRViewCreated: (qrController) =>
            controller.onQRViewCreated(context, qrController),
        overlay: QrScannerOverlayShape(
            borderColor: Colors.white, cutOutSize: scanArea));
  }

  Widget _buildEnterCodeView(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Colors.white,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/enter_qr_code_image.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.825,
      child: TextField(
        onChanged: (input) {
          code = input;
        },
        onSubmitted: (input) async {
          code = input;
          storeId = 15;
          couponId = 14;
          print(code);
          // coupon = await controller.getCouponById(1);
          coupon = await controller.checkCode(storeId!, couponId!, code);
          print(coupon);
          if (coupon != null) {
            // if (code.contains('GIAM30')) {
            title = "MÃ HỢP LỆ";
            content = 'Tên: ' +
                coupon!.name! +
                '\n' +
                'Mã: ' +
                coupon!.code! +
                '\n' +
                'Mô tả: ' +
                coupon!.description! +
                '\n' +
                'Ngày áp dụng: ' +
                coupon!.publishDate!.toString() +
                '\n' +
                'Ngày hết hạn: ' +
                coupon!.expireDate!.toString();
            isSuccess = true;
          } else {
            title = "LỖI";
            content =
                "Không thể áp dụng mã giảm giá. Mã giảm giá không hợp lệ hoặc không còn thời hạn sử dụng.";
            isSuccess = false;
          }
          _buildPopUp(context, title, content, isSuccess);
        },
        decoration: InputDecoration(
          isDense: true,
          // filled: true,
          fillColor: Colors.blue.shade100,
          border: OutlineInputBorder(),
          labelText: 'MÃ GIẢM GIÁ',
          hintText: 'E.g. ABCXYZ',
          // prefixIcon: Icon(Icons.favorite),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.check_circle,
              color: Colors.blue,
            ),
            onPressed: () async {
              storeId = 15;
              couponId = 14;
              print(code);
              // coupon = await controller.getCouponById(1);
              coupon = await controller.checkCode(storeId!, couponId!, code);
              print(coupon);
              if (coupon != null) {
                // if (code.contains('GIAM30')) {
                title = "MÃ HỢP LỆ";
                content = 'Tên: ' +
                    coupon!.name! +
                    '\n' +
                    'Mã: ' +
                    coupon!.code! +
                    '\n' +
                    'Mô tả: ' +
                    coupon!.description! +
                    '\n' +
                    'Ngày áp dụng: ' +
                    coupon!.publishDate!.toString() +
                    '\n' +
                    'Ngày hết hạn: ' +
                    coupon!.expireDate!.toString();
                isSuccess = true;
              } else {
                title = "LỖI";
                content =
                    "Không thể áp dụng mã giảm giá. Mã giảm giá không hợp lệ hoặc không còn thời hạn sử dụng.";
                isSuccess = false;
              }
              _buildPopUp(context, title, content, isSuccess);
              // FocusScopeNode currentFocus = FocusScope.of(context);
              // currentFocus.unfocus();
            },
          ),
        ),
      ),
    );
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
        textAlign: TextAlign.left,
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
        !isSuccess
            ? popup.button(
                label: 'Đóng',
                onPressed: () {
                  Navigator.of(context).pop();
                })
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Đóng',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: Text('Xem chi tiết'),
                  )
                ],
              )
      ],
      // bool barrierDismissible = false,
      // Widget close,
    );
  }
}
