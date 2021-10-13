import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ipsb_partner_app/src/common/constants.dart';
import 'package:ipsb_partner_app/src/pages/manage_locator_tag/controllers/manage_locator_tag_controller.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:ipsb_partner_app/src/pages/manage_locator_tag/views/manage_locator_tag_detail_page.dart';

class ManageLocatorTagPage extends GetView<ManageLocatorTagController> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return MaterialApp(
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
      appBar: AppBar(
        title: Text('Beacon Scanner'),
        leading: BackButton(
          color: Colors.black,
          onPressed: () => {controller.backToHome()},
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map((d) => ListTile(
                            title: Text(d.name),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return RaisedButton(
                                    child: Text('OPEN'),
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ManageLocatorTagDetailPage(
                                                  device: d,
                                                ))),
                                  );
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map(
                        (r) => _buildScanResult(
                          context,
                          r,
                          () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect();
                            return ManageLocatorTagDetailPage(device: r.device);
                          })),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: const Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: const Icon(Icons.search),
                onPressed: () => FlutterBlue.instance.startScan());
          }
        },
      ),
    );
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
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ScanResult result) {
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            result.device.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.caption),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanResult(
      BuildContext context, ScanResult result, VoidCallback? onTap) {
    if (!['Radioland iBeacon', 'Radioland-R2beacon']
        .contains(result.device.name)) {
      return Container();
    } else {
      controller.addBeacons(
          result.device.id.toString(), Constants.inactive, null, null);
      // return Obx(() {
      return ExpansionTile(
        title: _buildTitle(context, result),
        leading: Text(result.rssi.toString()),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AvatarGlow(
              glowColor: Colors.red,
              endRadius: 20.0,
              duration: Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: Material(
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: Image.network(
                    'https://cdn.iconscout.com/icon/premium/png-512-thumb/beacon-1427391-1206235.png',
                    height: 60,
                  ),
                  radius: 40.0,
                ),
              ),
            ),
          ],
        ),
        children: <Widget>[
          _buildAdvRow(context, 'Complete Local Name',
              result.advertisementData.localName),
          _buildAdvRow(context, 'Mac Address', '${result.device.id}'),
          _buildAdvRow(context, 'Tx Power Level',
              '${result.advertisementData.txPowerLevel ?? 'N/A'}'),
          RaisedButton(
            child: Text('CONNECT'),
            color: Colors.black,
            textColor: Colors.white,
            onPressed: (result.advertisementData.connectable) ? onTap : null,
          ),

          // Align(
          //   alignment: Alignment.center,
          //   child: RaisedButton(
          //     child: Text(controller.action.value),
          //     color: Colors.blue,
          //     textColor: Colors.white,
          //     onPressed: (result.advertisementData.connectable)
          //         ? () => controller.addBeacons(
          //             result.device.id.toString(), "Inactive", 12, 78)
          //         : null,
          //   ),
          // ),
        ],
      );
      // });
    }
  }
}
