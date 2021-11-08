import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';
import 'package:ipsb_partner_app/src/utils/firebase_helper.dart';


class ProfileController extends GetxController {
  final SharedStates sharedData = Get.find();
  Future<void> logOut() async {
    /// Place this on top before set account to null
    /// * Unsubscribe from topic before logout *
    FirebaseHelper helper = new FirebaseHelper();
    await helper.unsubscribeFromTopic("account_id_" + sharedData.account!.id.toString());

    BotToast.showText(text: "Logout Success");
    Get.offAndToNamed(Routes.login);
  }
}
