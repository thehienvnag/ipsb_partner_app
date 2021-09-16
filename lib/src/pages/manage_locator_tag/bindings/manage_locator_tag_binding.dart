import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/pages/manage_locator_tag/controllers/manage_locator_tag_controller.dart';

class ManageLocatorTagBinding extends Bindings {
  @override
  void dependencies() {
    // Bind Feedback controller
    Get.lazyPut<ManageLocatorTagController>(() => ManageLocatorTagController());
  }
}
