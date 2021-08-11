import 'package:get/get.dart';
import 'package:indoor_positioning_visitor/src/pages/check_qr_code/controllers/check_qr_code_controller.dart';

class CheckQRCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckQRCodeController>(() => CheckQRCodeController());
  }
}