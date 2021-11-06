import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/common/constants.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/services/api/notification_service.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';

class FirebaseHelper {

  final SharedStates states = Get.find();
  INotificationService _service = Get.find();
  static FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  String _fcmToken = "Get Firebase token";

  static FlutterLocalNotificationsPlugin flutterLocalNotificationInstance() {
    if (_flutterLocalNotificationsPlugin == null) {
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    }
    return _flutterLocalNotificationsPlugin!;
  }

  Future _showNotification(RemoteMessage message) async {
    RemoteNotification? data = message.notification;

    AndroidNotification? android = message.notification?.android;
    if (data != null) {
      flutterLocalNotificationInstance()
          .show(
              0,
              data.title,
              data.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                    'channel id', 'channel name',
                    channelDescription: 'channel desc',
                    icon: android?.smallIcon,
                    setAsGroupSummary: true,
                    importance: Importance.max,
                    priority: Priority.high),
                iOS: const IOSNotificationDetails(
                    presentAlert: true, presentSound: true),
              ),
              payload: 'referenceName')
          .then((value) => Future.delayed(const Duration(seconds: 2), () {
                FirebaseHelper.flutterLocalNotificationInstance().cancel(0);
              }));
      loadUnreadNotification();
      Get.dialog(_buildDialog(data.title, data.body, message.data));
    }
  }

  void loadUnreadNotification() async {
    states.unreadNotification.value =
    await _service.countNotification({"status": Constants.unread, "accountId" : states.account!.id.toString()});
  }

  requestingPermissionForIOS() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  getToken() async {
    String? token = await _messaging.getToken();
    _fcmToken = token!;
    print("Token: " + _fcmToken);
  }

  Future<dynamic> _onSelectNotification(payload) async {
    // implement logic
    print('onSelectNotification: ' + payload);
  }

  void initPushNotification() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: iosInitializationSettings);

    flutterLocalNotificationInstance().initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);

    FirebaseMessaging.onMessage.listen((message) {
      _showNotification(message);
    });
  }

  Future<void> subscribeToTopic(String topic) async {
    print(
        'FlutterFire Messaging Example: Subscribing to topic "' + topic + '".');
    await _messaging.subscribeToTopic(topic);
    print('FlutterFire Messaging Example: Subscribing to topic "' +
        topic +
        '" successful.');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    print('FlutterFire Messaging Example: Unsubscribing from topic "' +
        topic +
        '".');
    await _messaging.unsubscribeFromTopic(topic);
    print('FlutterFire Messaging Example: Unsubscribing from topic "' +
        topic +
        '" successful.');
  }

  Widget _buildDialog(String? title, String? body, Map<String, dynamic> data) {
    if (data['notificationType'] == 'feedback_changed') {
      return AlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: <Widget>[
          FlatButton(
            child: const Text('CLOSE'),
            onPressed: () {
              Get.back();
            },
          ),
          FlatButton(
            child: const Text('GO TO FEEDBACK'),
            onPressed: () {
              Get.back();
              Get.toNamed(
                Routes.feedbacks,
                parameters: {
                  "couponId": data['couponId'],
                },
              );
            },
          ),
        ],
      );
    }
    return AlertDialog(
      title: Text(title!),
      content: Text(body!),
      actions: <Widget>[
        FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    );
  }

  Future<void> setupInteractedMessage() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['notificationType'] == 'feedback_changed') {
        Get.toNamed(Routes.feedbacks,
            parameters: {"couponId": message.data['couponId']});
      }
    });
  }
}
