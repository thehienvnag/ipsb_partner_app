import 'package:get/get.dart';
import 'package:indoor_positioning_visitor/src/pages/manage_feedback/controllers/manage_feedback_controller.dart';

class ManageFeedbackBinding extends Bindings {
  @override
  void dependencies() {
    // Bind Feedback controller
    Get.lazyPut<ManageFeedbackController>(() => ManageFeedbackController());
  }
}
