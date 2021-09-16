import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/services/api/locator_tag_service.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';

class ManageLocatorTagController extends GetxController {
  final action = "INSERT".obs;

  final flutterBlueInstance = FlutterBlue.instance.obs;
  final scanResult = FlutterBlue.instance.scanResults.obs;

  ScanResult? result;
  ILocatorTagService locatorTagService = Get.find();

  @override
  void dispose() {
    super.dispose();
  }

  void addBeacons(
      String macAddress, String status, int floorPlanId, int locationId) async {
    await locatorTagService.postLocatorTag(
                macAddress, status, floorPlanId, locationId) !=
            null
        ? action.value = "INSERTED"
        : action.value = "FAILED";
  }

  SharedStates states = Get.find();
  void backToHome() {
    states.bottomBarSelectedIndex.value = 0;
    Get.offNamed(Routes.home);
  }
}
