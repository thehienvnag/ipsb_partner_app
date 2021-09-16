import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/pages/manage_feedback/controllers/manage_feedback_controller.dart';

class ManageFeedbackBinding extends Bindings {
  @override
  void dependencies() {
    // Bind Feedback controller
    Get.lazyPut<ManageFeedbackController>(() => ManageFeedbackController());
  }
}
