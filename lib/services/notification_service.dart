import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:my_crumbl/firebase_options.dart';

class NotificationService with ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  String _firebaseToken = '';

  String get firebaseToken => _firebaseToken;
  final String _nativeToken = '';

  String get nativeToken => _nativeToken;

  // Use this method to detect when a new notification or a schedule is created
  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    print('NotificationService.onNotificationCreatedMethod');
  }

  // Use this method to detect every time that a new notification is displayed
  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    print('NotificationService.onNotificationDisplayedMethod');
  }

  // Use this method to detect if the user dismissed a notification
  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print('NotificationService.onDismissActionReceivedMethod');
    if (receivedAction.channelKey == 'basic_channel' && Platform.isIOS) {
      AwesomeNotifications().getGlobalBadgeCounter().then((badgeCounter) {
        AwesomeNotifications().setGlobalBadgeCounter(badgeCounter - 1);
      });
    }
  }

  // Use this method to detect when the user taps on a notification or action button
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print('NotificationService.onActionReceivedMethod');
    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/notification-page',
    //         (route) => (route.settings.name != '/notification-page') || route.isFirst,
    //     arguments: receivedAction);
  }

  static Future<void> resetBadge() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<String> requestFirebaseToken() async {
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        print('Firebase is available on this project');
        return await AwesomeNotificationsFcm().requestFirebaseAppToken();
      } catch (exception) {
        print('Error requesting firebase token: $exception');
        print('$exception');
      }
    } else {
      print('Firebase is not available on this project');
    }
    return '';
  }

  static Future<void> initializeLocalNotifications(
      {required bool debug}) async {
    await AwesomeNotifications().initialize(
        'resource://drawable/res_notif_icon',
        [
          NotificationChannel(
              channelKey: 'basic_channel',
              channelName: 'Basic Notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: const Color(0xFF9D50DD),
              importance: NotificationImportance.High,
              channelShowBadge: true),
        ],
        debug: debug);
  }

  static Future<void> initializeRemoteNotifications(
      {required bool debug}) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await AwesomeNotificationsFcm().initialize(
        onFcmSilentDataHandle: onFcmSilentDataHandle,
        onFcmTokenHandle: onFcmTokenHandle,
        onNativeTokenHandle: onNativeTokenHandle,
        licenseKeys: [
          'AsbFvetKGsLZ+A07LlgdC6XNUMj2aI6Az3Xs2BweUZGDA8+lMFM6Bg/6G6XM03ttsxf4KVtuMCZKvMWSt+l1EFIbSyEUK0Lv5jyjiFESM/zN0/0kfe+u66js8Da8H1uVN1fs+k5NR+zEiyOsHz3wdxuWT/HMVSn/E5btyY58ILM='
        ],
        debug: debug);
  }

  // Use this method to execute on background when a silent data arrives
  // (even while terminated)
  @pragma('vm:entry-point')
  static Future<void> onFcmSilentDataHandle(FcmSilentData silentData) async {
    Fluttertoast.showToast(
        msg: 'Silent data received',
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16);

    print('"SilentData": ${silentData.toString()}');

    if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
      print('bg');
    } else {
      print('FOREGROUND');
    }

    print('onSilentDataHandle received a FcmSilentData execution');
    await executeLongTaskTest();
  }

  static Future<void> executeLongTaskTest() async {
    print('starting long task');
    await Future.delayed(Duration(seconds: 4));
    final url = Uri.parse('http://google.com');
    final re = await http.get(url);
    print(re.body);
    print('long task done');
  }

  // Use this method to detect when a new fcm token is received
  @pragma('vm:entry-point')
  static Future<void> onFcmTokenHandle(String token) async {
    Fluttertoast.showToast(
        msg: 'Fcm token received',
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16);
    debugPrint('Firebase Token:"$token"');

    _instance._firebaseToken = token;
    _instance.notifyListeners();
  }

  // Use this method to detect when a new native token is received
  @pragma('vm:entry-point')
  static Future<void> onNativeTokenHandle(String token) async {
    Fluttertoast.showToast(
        msg: 'Native token received',
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16);
    debugPrint('Native Token:"$token"');
  }

  static Future<void> initializeNotificationListeners() async {
    // Only after at least the action method is set, the notification events are delivered
    await AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod);
  }

  static Future<void> getInitialNotificationAction() async {
    final ReceivedAction? receivedAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);
    if (receivedAction == null) return;
    Fluttertoast.showToast(
        msg: 'Notification action launched app: $receivedAction',
        backgroundColor: Colors.deepPurple);
    print('Notification action launched app: $receivedAction');
  }

  // // Use this method to detect when a new notification or a schedule is created
  // @pragma('vm:entry-point')
  // static Future<void> notificationCreatedMethod(
  //     ReceivedNotification receivedNotification) async {
  //   Fluttertoast.showToast(
  //       msg:
  //           'Notification from ${AwesomeAssertUtils.toSimpleEnumString(receivedNotification.createdSource)} created',
  //       backgroundColor: Colors.green);
  // }
  //
  // // Use this method to detect every time that a new notification is displayed
  // @pragma('vm:entry-point')
  // static Future<void> notificationDisplayedMethod(
  //     ReceivedNotification receivedNotification) async {
  //   Fluttertoast.showToast(
  //       msg:
  //           'Notification from ${AwesomeAssertUtils.toSimpleEnumString(receivedNotification.createdSource)} displayed',
  //       backgroundColor: Colors.blue);
  // }
  //
  // // Use this method to detect if the user dismissed a notification
  // @pragma('vm:entry-point')
  // static Future<void> dismissActionReceivedMethod(
  //     ReceivedAction receivedAction) async {
  //   Fluttertoast.showToast(
  //       msg:
  //           'Notification from ${AwesomeAssertUtils.toSimpleEnumString(receivedAction.createdSource)} dismissed',
  //       backgroundColor: Colors.orange);
  // }
  //
  // // Use this method to detect when the user taps on a notification or action button
  // @pragma('vm:entry-point')
  // static Future<void> actionReceivedMethod(
  //     ReceivedAction receivedAction) async {
  //   final String? actionSourceText =
  //       AwesomeAssertUtils.toSimpleEnumString(receivedAction.actionLifeCycle);
  //
  //   if (receivedAction.actionType == ActionType.SilentBackgroundAction) {
  //     print(
  //         'myActionReceivedMethod received a SilentBackgroundAction execution');
  //     await executeLongTaskTest();
  //     return;
  //   }
  //
  //   Fluttertoast.showToast(
  //       msg: 'Notification action captured on $actionSourceText');
  //
  //   // String targetPage = PAGE_NOTIFICATION_DETAILS;
  //   //
  //   // // Avoid to open the notification details page over another details page already opened
  //   // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(targetPage,
  //   //         (route) => (route.settings.name != targetPage) || route.isFirst,
  //   //     arguments: receivedAction);
  // }

  static Future<bool> requireUserNotificationPermissions(BuildContext context,
      {String? channelKey}) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await showRequestUserPermissionDialog(context, channelKey: channelKey);
      isAllowed = await AwesomeNotifications().isNotificationAllowed();
    }
    return isAllowed;
  }

  static Future<void> showPermissionPage() async {
    await AwesomeNotifications().showNotificationConfigPage();
  }

  static Future<void> showNotificationConfigPage() async {
    AwesomeNotifications().showNotificationConfigPage();
  }

  static Future<void> showRequestUserPermissionDialog(BuildContext context,
      {String? channelKey}) async {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xfffbfbfb),
        title: const Text('Get Notified!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/splash.png',
              height: 200,
              fit: BoxFit.fitWidth,
            ),
            const Text(
              'Allow Awesome Notifications to send you beautiful notifications!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.grey),
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: const Text('Later', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.deepPurple),
            onPressed: () async {
              await AwesomeNotifications()
                  .requestPermissionToSendNotifications(channelKey: channelKey);
              Navigator.of(context).pop();
            },
            child: const Text('Allow', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
