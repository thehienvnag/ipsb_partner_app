import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ipsb_partner_app/src/pages/manage_locator_tag/controllers/manage_locator_tag_controller.dart';
import 'package:ipsb_partner_app/src/utils/formatter.dart';
import 'package:ipsb_partner_app/src/utils/utils.dart';

class ManageLocatorTagPage extends GetView<ManageLocatorTagController> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return _findBeaconScreen(context);
            }
            return _bluetoothOffScreen(context, state);
          }),
    );
  }

  Widget _findBeaconScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Obx(() {
              return _buildAppBarTitle(context, controller.isRunning.value);
            }),
            _buildDeleteIcon(context),
            _buildCheckIcon(context),
          ],
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () => {controller.backToHome()},
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: Obx(() {
        return _buildFloatingButton(context, controller.isRunning.value,
            controller.isInserting.contains(true));
      }),
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildLinearProgressIndicator(controller.isRunning.value),
              _buildBody(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (controller.rssiArray.isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 150, right: 20),
              height: 250,
              width: 250,
              child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/application-test-4750a.appspot.com/o/other_image%2FemptyiBeacon.png?alt=media&token=1a48fe5c-3cf9-4303-9cd6-8ac60dc2fba2'),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                'Looks like there is nothing here just yet!',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(top: 15),
            //   width: 320,
            //   child: Text(
            //     'Come back to check after receiving new notification',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontWeight: FontWeight.w400,
            //       fontSize: 16,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    }
    return Container(
      child: Column(
        children: [
          // Obx(() {
          //   return
          // }),
          // Obx(() {
          //   return
          _buildScanResult(context),
          // })
        ],
      ),
    );
  }

  Widget _buildAppBarTitle(BuildContext context, bool isRunning) {
    final width = MediaQuery.of(context).size.width;
    if (!isRunning) {
      return Container(
          width: width * 0.55,
          child: Text(
            controller.title.value,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ));
    } else {
      return Container(
        width: width * 0.55,
        child: Row(
          children: [
            Text(
              controller.title.value,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
              height: 10,
            ),
            SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildDeleteIcon(BuildContext context) {
    return SizedBox(
      width: 40,
      child: IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => _buildAlertDialog(
                  context,
                  "Delete all",
                  "Are you sure you want to delete all the previous scans?",
                  () => {
                        Get.back(),
                        controller.clearResult(),
                      }),
              barrierDismissible: false);
        },
        icon: Icon(Icons.delete_sweep),
        color: Colors.red,
      ),
    );
  }

  Widget _buildCheckIcon(BuildContext context) {
    return SizedBox(
      width: 20,
      child: IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => _buildAlertDialog(
                  context,
                  "Check beacons",
                  "Do you want to check whether the scanned beacons already exist in the system?",
                  () => {
                        Get.back(),
                        showDialog(
                            context: context,
                            builder: (_) =>
                                _buildAlertDialogCircularProgressIndicator(
                                    context,
                                    "Please wait while system checks for beacons"),
                            barrierDismissible: false),
                        controller
                            .checkBeaconExist(context)
                            .then((value) => Get.back()),
                      }),
              barrierDismissible: false);
        },
        icon: Icon(Icons.update),
        color: Colors.black,
      ),
    );
  }

  Widget _buildFloatingButton(
      BuildContext context, bool isRunning, bool isInserting) {
    return MaterialButton(
      onPressed: () {
        !isInserting
            ? controller.monitoring()
            : showDialog(
                context: context,
                builder: (_) => _buildAlertDialogNonCallBack(
                    context,
                    "Unable to scan right now",
                    "You can not scan for nearby beacons while insert or update "
                        "previous beacon to system"));
      },
      color: !isInserting
          ? !isRunning
              ? Colors.blue
              : Colors.red
          : Colors.grey,
      textColor: Colors.white,
      child: Icon(
        !isInserting
            ? !isRunning
                ? Icons.play_arrow
                : Icons.stop
            : Icons.play_arrow,
        size: 24,
      ),
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
    );
  }

  Widget _buildLinearProgressIndicator(bool isRunning) {
    if (isRunning) {
      return LinearProgressIndicator(
        color: Colors.blue,
      );
    } else {
      return SizedBox();
    }
  }

  Widget _bluetoothOffScreen(BuildContext context, BluetoothState? state) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cancel),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        mini: true,
        onPressed: () => {
          controller.backToHome(),
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }

  Widget _buildTitle(
      BuildContext context, String deviceName, String macAddress, int index) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          deviceName != "null"
              ? deviceName
              : "Radioland_iBeacon_" + (index + 1).toString(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 16),
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(
                macAddress,
                style: TextStyle(fontSize: 11),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildTrailing(
      BuildContext context, String distance, DateTime scanTime) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: distance,
                // overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20),
              ),
              TextSpan(text: " m")
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Text(
            Formatter.dateCaculator(scanTime),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
    );
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          // Theme.of(context).textTheme.caption),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14),
              // Theme.of(context)
              //     .textTheme
              //     .caption
              //     ?.apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvColumnRow(BuildContext context, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 14),
                softWrap: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      BuildContext context,
      IconData icon,
      Color color,
      String text,
      String alternativeTextBasedOnStatus,
      VoidCallback onTap,
      VoidCallback alternativeOnTapBasedOnStatus,
      bool isInserting,
      bool status,
      {isOnRight = false}) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Align(
      alignment: !isOnRight ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: !status
              ? isInserting
                  ? null
                  : onTap
              : isInserting
                  ? null
                  : alternativeOnTapBasedOnStatus,
          child: Container(
            height: height * 0.05,
            width: width * 0.6,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isInserting ? Colors.grey : color,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: !isOnRight
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 500,
                        width: width * 0.15,
                        // margin:
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Center(
                          child: Icon(
                            icon,
                            size: width * 0.05,
                            color: isInserting ? Colors.grey : color,
                          ),
                        ),
                      ),
                      !status
                          ? Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                              child: Text(
                                text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ))
                          : Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text(
                                alternativeTextBasedOnStatus,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9),
                              ),
                            ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text(
                          text,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                      Container(
                        height: 500,
                        width: width * 0.15,
                        // margin:
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Center(
                          child: Icon(
                            icon,
                            size: width * 0.05,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountDown(BuildContext context, Color color, bool isInsert,
      bool status, int index) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return !isInsert
        ? _buildStatus(context, status)
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: color,
                  ),
                  SizedBox(
                    width: 8,
                    height: 8,
                  ),
                  SizedBox(
                    height: 20.0,
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: 20,
                            child: new CircularProgressIndicator(
                                strokeWidth: 1,
                                value: 1 -
                                    (double.parse(controller
                                            .countDownNumberArray[index]
                                            .toString())) /
                                        20,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.blue)),
                          ),
                        ),
                        Center(
                            child: Padding(
                          padding: controller.countDownNumberArray[index]
                                      .toString()
                                      .length ==
                                  2
                              ? const EdgeInsets.only(left: 3)
                              : const EdgeInsets.only(left: 7),
                          child: Text(
                            controller.countDownNumberArray[index].toString(),
                            style: TextStyle(fontSize: 12),
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildStatus(BuildContext context, bool status) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      child: Row(
        children: [
          !status
              ? Container(
                  width: 60,
                  child: Text(
                    'Not in the system',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ))
              : Container(
                  child: Text(
                  'In the system',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                )),
          SizedBox(
            width: 5,
            height: 5,
          ),
          !status
              ? Icon(
                  Icons.cloud_off_sharp,
                  color: Colors.red,
                )
              : Icon(Icons.cloud_done, color: Colors.green),
        ],
      ),
    );
  }

  Widget _buildAlertDialog(BuildContext context, String title, String content,
      VoidCallback onPress) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => {Get.back()},
          child: Text("CANCEL"),
        ),
        TextButton(
          onPressed: () => {onPress()},
          child: Text("OK"),
        ),
      ],
    );
  }

  Widget _buildAlertDialogNonCallBack(
      BuildContext context, String title, String content) {
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

  Widget _buildAlertDialogCircularProgressIndicator(
      BuildContext context, String title) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 50,
        height: 50,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget _buildScanResult(BuildContext context) {
    // controller.addBeacons(
    //     result.device.id.toString(), Constants.inactive, null, null);
    // return Obx(() {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        String uuidString = Utils.getUuid(
            controller.uuidArray[index], controller.macAddressArray[index]);
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: ExpansionTile(
            title: _buildTitle(context, controller.nameArray[index],
                controller.uuidArray[index], index),
            trailing: _buildTrailing(
                context, controller.distanceArray[index], DateTime.now()),
            children: <Widget>[
              Divider(
                thickness: 1,
                indent: 15,
                endIndent: 15,
              ),
              _buildAdvRow(
                context,
                'UUID',
                uuidString,
              ),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildAdvColumnRow(
                      context, 'Major', controller.majorArray[index]),
                  _buildAdvColumnRow(
                      context, 'Minor', controller.minorArray[index]),
                  _buildAdvColumnRow(
                      context, 'RSSI', controller.rssiArray[index] + " dBm"),
                ],
              ),
              Row(
                children: [
                  _buildButton(
                    context,
                    CupertinoIcons.add_circled_solid,
                    Colors.blue,
                    "CLICK TO INSERT",
                    "CLICK TO UPDATE TX POWER",
                    () => {
                      controller.addBeacons(
                        context,
                        uuidString,
                        index,
                      ),
                      // controller.isInserting.remove(index),
                      // controller.isInserting.insert(index, true),
                    },
                    () => {
                      controller.updateTxPower(context, uuidString, index),
                    },
                    controller.isInserting[index],
                    controller.statusInSystemArray[index],
                  ),
                  _buildCountDown(
                      context,
                      Colors.blue,
                      controller.isInserting[index],
                      controller.statusInSystemArray[index],
                      index),
                ],
              ),

              // Align(
              //   alignment: Alignment.center,
              //   child: RaisedButton(
              //     child: Text('INSERT'),
              //     color: Colors.blue,
              //     textColor: Colors.white,
              //     onPressed: (controller.isRunning.value)
              //         ? () => controller.addBeacons(
              //             2.toString(), "Inactive", 12, 78)
              //         : null,
              //   ),
              // ),
            ],
          ),
        );
      },
      itemCount: controller.rssiArray.length,
    );
  }
}
