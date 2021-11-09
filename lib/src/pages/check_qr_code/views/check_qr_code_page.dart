import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ipsb_partner_app/src/models/coupon.dart';
import 'package:ipsb_partner_app/src/pages/check_qr_code/controllers/check_qr_code_controller.dart';
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
          SizedBox(
            height: 100,
          ),
          _buildQrView(context),
          Align(alignment: Alignment.topCenter, child: _buildQRTitle(context)),
          _buildQRIcon(context),
        ],
      ),
    );
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

  Widget _buildQRTitle(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.65,
      height: height * 0.16,
      margin: EdgeInsets.only(top: 120, bottom: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Scan QR code',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Text('Scan the QR code from the coupon that user has saved',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 230.0
        : 260.0;
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
}
