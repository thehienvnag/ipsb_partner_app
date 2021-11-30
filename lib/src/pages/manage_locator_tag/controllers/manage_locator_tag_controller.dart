import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ipsb_partner_app/src/algorithm/ipsb_positioning/filters/kalman_filter_1d.dart';
import 'package:ipsb_partner_app/src/models/locator_tag.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/services/api/locator_tag_service.dart';
import 'package:ipsb_partner_app/src/services/global_states/auth_services.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';
import 'package:ipsb_partner_app/src/utils/firebase_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class ManageLocatorTagController extends GetxController {
  final flutterBlueInstance = FlutterBlue.instance.obs;
  final scanResult = FlutterBlue.instance.scanResults.obs;

  ScanResult? result;
  ILocatorTagService _locatorTagService = Get.find();
  SharedStates sharedStates = Get.find();

  final title = "Beacon Scanner".obs;
  final nameArray = <String>[].obs;
  final macAddressArray = <String>[].obs;
  final rssiArray = <String>[].obs;
  final distanceArray = <String>[].obs;
  final uuidArray = <String>[].obs;
  final majorArray = <String>[].obs;
  final minorArray = <String>[].obs;
  final isRunning = false.obs;
  final isInserting = <bool>[].obs;
  final statusInSystemArray = <bool>[].obs;
  final beaconArray = <LocatorTag?>[].obs;

  final insertBeaconArray = <String>[].obs;
  final countDownNumberArray = <int>[].obs;

  List<String> stringArray = [];

  final List<List<double>> kalmanFilterRssiArray = <List<double>>[].obs;

  // String macAddressValue = "";

  // Map<String, List<String>> insertRSSIArray = new Map();

  // String uuid = "";

  StreamController<String> beaconEventsController =
      StreamController<String>.broadcast();

  @override
  void onInit() {
    super.onInit();
    // loadAllBeacons();
  }

  @override
  void dispose() {
    beaconEventsController.close();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    String macAddressValue = "";
    if (Platform.isAndroid) {
      //Prominent disclosure
      await BeaconsPlugin.setDisclosureDialogMessage(
          title: "Need Location Permission",
          message: "This app collects location data to work with beacons.");

      //Only in case, you want the dialog to be shown again. By Default, dialog will never be shown if permissions are granted.
      //await BeaconsPlugin.clearDisclosureDialogShowFlag(false);
    }

    BeaconsPlugin.listenToBeacons(beaconEventsController);

    BeaconsPlugin.setForegroundScanPeriodForAndroid(
        foregroundScanPeriod: 2200, foregroundBetweenScanPeriod: 10);

    BeaconsPlugin.setBackgroundScanPeriodForAndroid(
        backgroundScanPeriod: 2200, backgroundBetweenScanPeriod: 10);

    beaconEventsController.stream.listen(
        (data) {
          if (data.isNotEmpty && isRunning.value) {
            macAddressValue = _getValueWithColonFromData("macAddress", data);

            if (!macAddressArray.contains(macAddressValue)) {
              nameArray.add(_getValueFromData("name", data));
              macAddressArray.add(macAddressValue);
              rssiArray.add(_getValueFromData("rssi", data));
              distanceArray.add(_getValueFromData("distance", data));
              uuidArray.add(_getValueFromData("uuid", data));
              majorArray.add(_getValueFromData("major", data));
              minorArray.add(_getValueFromData("minor", data));
              kalmanFilterRssiArray.add([double.parse(_getValueFromData("rssi", data))]);
              
              isInserting.add(false);
              statusInSystemArray.add(false);
              countDownNumberArray.add(20);
              // statusInSystemArray.add(beaconArray.singleWhere(
              //         (item) => item!.macAddress == macAddress,
              //         orElse: () => null) !=
              //     null);
            } else {
              int index = macAddressArray.indexOf(macAddressValue);
              kalmanFilterRssiArray[index].add(double.parse(_getValueFromData("rssi", data)));
              rssiArray.removeAt(index);
              rssiArray.insert(index, _getValueFromData("rssi", data));
              distanceArray.removeAt(index);
              distanceArray.insert(index, _getValueFromData("distance", data));
            }
          }
        },
        onDone: () {},
        onError: (error) {
          print("Error: $error");
        });

    //Send 'true' to run in background
    await BeaconsPlugin.runInBackground(true);

    if (Platform.isAndroid) {
      BeaconsPlugin.channel.setMethodCallHandler((call) async {
        if (call.method == 'scannerReady') {
          await BeaconsPlugin.startMonitoring();
          isRunning.value = true;
        }
      });
    } else if (Platform.isIOS) {
      await BeaconsPlugin.startMonitoring();
      isRunning.value = true;
    }
  }

  Future<void> monitoring() {
    if (!isRunning.value) {
      title.value = "Scanning";
      isRunning.value = true;
      initPlatformState();
      return BeaconsPlugin.startMonitoring();
    } else {
      title.value = "Beacon Scanner";
      isRunning.value = false;
      return BeaconsPlugin.stopMonitoring();
    }
  }

  void addBeacons(BuildContext context, String uuid, int index) async {
    if (insertBeaconArray.length == 3) {
      Get.dialog(_buildAlertDialog(context, "Unable to insert", "You can only interact with 3 iBeacons at a time"));
      return;
    }
    int? buildingId = AuthServices.userLoggedIn.value.building!.id;
    insertBeaconArray.add("item_" + index.toString());
    isInserting[index] = true;
    rssiArray.add("item");
    rssiArray.remove("item");
    LocatorTag? locatorTag =
        await _locatorTagService.postLocatorTag(uuid, buildingId!);

    if (locatorTag != null) {
      BotToast.showText(
          text: "Insert " +
              (nameArray[index] != "null"
                  ? nameArray[index]
                  : "Radioland_iBeacon_" + (index + 1).toString()) +
              " successfully",
          textStyle: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          duration: const Duration(seconds: 2));
    } else {
      insertBeaconArray.remove("item_" + index.toString());
      statusInSystemArray[index] = true;
      isInserting[index] = false;
      rssiArray.add("item");
      rssiArray.remove("item");
      _createNotification(
          "Insert beacon failed",
          "Can not insert " +
              (nameArray[index] != "null"
                  ? nameArray[index]
                  : "Radioland_iBeacon_" + (index + 1).toString()) +
              " into the system because it already exists");
      return;
    }
    if (!isRunning.value) {
      beaconEventsController = new StreamController<String>.broadcast();
      title.value = "Executing";
      isRunning.value = true;
      // initPlatformState();
      BeaconsPlugin.startMonitoring();
    }

    String macAddressValue = "";
    double rssi = 0;
    KalmanFilter1d filter1d = new KalmanFilter1d();

    Timer timer = new Timer.periodic(
        Duration(seconds: 1),
        (timer) => {
              if (countDownNumberArray[index] == 0)
                {
                  title.value = "Beacon Scanner",
                  insertBeaconArray.remove("item_" + index.toString()),
                  rssiArray.add("item"),
                  rssiArray.remove("item"),
                  countDownNumberArray[index] = 20,
                  statusInSystemArray[index] = true,
                  isInserting[index] = false,
                  timer.cancel(),
                  _locatorTagService
                      .updateLocatorTagByUUID(uuid, rssi)
                      .then((value) => {
                            if (!value)
                              {
                                _createNotification(
                                    "Update beacon failed",
                                    "Can not update " +
                                        (nameArray[index] != "null"
                                            ? nameArray[index]
                                            : "Radioland_iBeacon_" +
                                                (index + 1).toString()) +
                                        " into system due to error")
                              }
                            else
                              {
                                BotToast.showText(
                                    text: "Update " +
                                        (nameArray[index] != "null"
                                            ? nameArray[index]
                                            : "Radioland_iBeacon_" +
                                                (index + 1).toString()) +
                                        " successfully",
                                    textStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    duration: const Duration(seconds: 2)),
                              }
                          }),
                  if (insertBeaconArray.isEmpty)
                    {
                      beaconEventsController =
                          new StreamController<String>.broadcast(),
                      isRunning.value = false,
                      BeaconsPlugin.stopMonitoring(),
                    }
                }
              else
                {
                  BeaconsPlugin.listenToBeacons(beaconEventsController),
                  beaconEventsController.stream.listen(
                      (data) {
                        if (data.isNotEmpty && isRunning.value) {
                          macAddressValue = jsonDecode(data)['uuid'];

                          if (macAddressValue == uuid) {
                            rssi = filter1d.filter(
                                double.parse(_getValueFromData("rssi", data)));
                          } else {}
                        }
                      },
                      onDone: () {},
                      onError: (error) {
                        print("Error: $error");
                      }),
                  // executeMethod.insertRSSI(),
                  rssiArray.add("item"),
                  rssiArray.remove("item"),
                  --countDownNumberArray[index],
                }
            });
  }

  SharedStates states = Get.find();

  void updateTxPower(BuildContext context, String uuid, int index) async {
    if (insertBeaconArray.length == 3) {
      Get.dialog(_buildAlertDialog(context, "Unable to update", "You can only interact with 3 iBeacons at a time"));
      return;
    }
    insertBeaconArray.add("item_" + index.toString());
    isInserting[index] = true;
    rssiArray.add("item");
    rssiArray.remove("item");

    if (!isRunning.value) {
      beaconEventsController = new StreamController<String>.broadcast();
      title.value = "Executing";
      isRunning.value = true;
      // initPlatformState();
      BeaconsPlugin.startMonitoring();
    }

    String macAddressValue = "";
    double rssi = 0;
    KalmanFilter1d filter1d = new KalmanFilter1d();

    Timer timer = new Timer.periodic(
        Duration(seconds: 1),
        (timer) => {
              if (countDownNumberArray[index] == 0)
                {
                  title.value = "Beacon Scanner",
                  insertBeaconArray.remove("item_" + index.toString()),
                  rssiArray.add("item"),
                  rssiArray.remove("item"),
                  countDownNumberArray[index] = 20,
                  statusInSystemArray[index] = true,
                  isInserting[index] = false,
                  timer.cancel(),
                  _locatorTagService
                      .updateLocatorTagByUUID(uuid, rssi)
                      .then((value) => {
                            if (!value)
                              {
                                _createNotification(
                                    "Update beacon failed",
                                    "Can not update " +
                                        (nameArray[index] != "null"
                                            ? nameArray[index]
                                            : "Radioland_iBeacon_" +
                                                (index + 1).toString()) +
                                        " into system due to error")
                              }
                            else
                              {
                                BotToast.showText(
                                    text: "Update " +
                                        (nameArray[index] != "null"
                                            ? nameArray[index]
                                            : "Radioland_iBeacon_" +
                                                (index + 1).toString()) +
                                        " successfully",
                                    textStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    duration: const Duration(seconds: 2)),
                              }
                          }),
                  if (insertBeaconArray.isEmpty)
                    {
                      beaconEventsController =
                          new StreamController<String>.broadcast(),
                      isRunning.value = false,
                      BeaconsPlugin.stopMonitoring(),
                    }
                }
              else
                {
                  BeaconsPlugin.listenToBeacons(beaconEventsController),
                  beaconEventsController.stream.listen(
                      (data) {
                        if (data.isNotEmpty && isRunning.value) {
                          // macAddressValue =
                          //     _getValueWithColonFromData("uuid", data);
                          macAddressValue = jsonDecode(data)['uuid'];
                          if (macAddressValue == uuid) {
                            rssi = filter1d.filter(
                                double.parse(_getValueFromData("rssi", data)));
                          }
                        }
                      },
                      onDone: () {},
                      onError: (error) {
                        print("Error: $error");
                      }),
                  // executeMethod.insertRSSI(),
                  rssiArray.add("item"),
                  rssiArray.remove("item"),
                  --countDownNumberArray[index],
                }
            });
  }

  void backToHome() {
    states.bottomBarSelectedIndex.value = 0;
    Get.offNamed(Routes.home);
  }

  void clearResult() {
    nameArray.value = <String>[].obs;
    macAddressArray.value = <String>[].obs;
    rssiArray.value = <String>[].obs;
    distanceArray.value = <String>[].obs;
    uuidArray.value = <String>[].obs;
    majorArray.value = <String>[].obs;
    minorArray.value = <String>[].obs;
    isInserting.value = <bool>[].obs;
    statusInSystemArray.value = <bool>[].obs;
  }

  String _getValueFromData(String field, String data, {bool getName = false}) {
    String value = "";
    stringArray = data.split(",");
    stringArray = stringArray[getFieldPositionInData(field)].split(":");
    if (getName) {
      value = stringArray[0].substring(2, stringArray[0].length - 1);
    } else {
      value = stringArray[1].substring(2, stringArray[1].length - 1);
    }

    return value;
  }

  String _getValueWithColonFromData(String field, String data,
      {bool getName = false}) {
    String value = "";
    stringArray = data.split(",");
    stringArray = stringArray[getFieldPositionInData(field)].split(":");
    if (getName) {
      value = stringArray[0].substring(2, stringArray[0].length - 1);
    } else {
      if (field == "macAddress") {
        value = stringArray[1].substring(2) +
            ":" +
            stringArray[2] +
            ":" +
            stringArray[3] +
            ":" +
            stringArray[4] +
            ":" +
            stringArray[5] +
            ":" +
            stringArray[6].substring(0, stringArray[6].length - 1);
        return value;
        // } else if (field == "scanTime") {
        //   value = stringArray[1].substring(2) +
        //       ":" +
        //       stringArray[2] +
        //       ":" +
        //       stringArray[3].substring(0, stringArray[3].length - 1);
        //   return value;
      }
    }

    return "";
  }

  int getFieldPositionInData(String field) {
    switch (field) {
      case "name":
        return 0;
      case "uuid":
        return 1;
      case "macAddress":
        return 2;
      case "major":
        return 3;
      case "minor":
        return 4;
      case "distance":
        return 5;
      case "proximity":
        return 6;
      case "scanTime":
        return 7;
      case "rssi":
        return 8;
      case "txPower":
        return 9;
    }
    return -1;
  }

  void loadAllBeacons() async {
    int? buildingId = AuthServices.userLoggedIn.value.building?.id;
    if (buildingId == null) return;
    beaconArray.value =
        await _locatorTagService.getAllLocatorTagByBuildingId(buildingId);
  }

  void _createNotification(String title, String message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await FirebaseHelper.flutterLocalNotificationInstance().show(
      0,
      title,
      message,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  Future<void> checkBeaconExist(BuildContext context) async {
    int? buildingId = AuthServices.userLoggedIn.value.building?.id;
    if (buildingId == null) return;

    beaconArray.value =
        await _locatorTagService.getAllLocatorTagByBuildingId(buildingId);

    if (beaconArray.isNotEmpty) {
      for (int i = 0; i < macAddressArray.length; i++) {
        statusInSystemArray[i] = beaconArray
                .singleWhereOrNull((item) => item!.uuid == uuidArray[i]) !=
            null;
        rssiArray.add("item");
        rssiArray.remove("item");
      }
    } else {
      for (int i = 0; i < statusInSystemArray.length; i++) {
        statusInSystemArray[i] = false;
      }
      rssiArray.add("item");
      rssiArray.remove("item");
    }
  }

  Widget _buildAlertDialog(BuildContext context, String title, String content) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => {Get.back()},
          child: Text("OK"),
        ),
      ],
    );
  }
}
