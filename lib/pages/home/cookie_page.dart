import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/pages/home/cookie_list.dart';
import 'package:my_crumbl/pages/info_page.dart';
import 'package:my_crumbl/services/auth_service.dart';
import 'package:my_crumbl/services/data_repository.dart';
import 'package:my_crumbl/services/notification_service.dart';
import 'package:my_crumbl/shared/loading_page.dart';
import 'package:provider/provider.dart';

class CookiePage extends StatefulWidget {
  const CookiePage({super.key});

  @override
  State<CookiePage> createState() => _CookiePageState();
}

class _CookiePageState extends State<CookiePage> with WidgetsBindingObserver {
  final AuthService _auth = AuthService();
  late final StreamSubscription<QuerySnapshot> _allCookiesSubscription;
  late final StreamSubscription<QuerySnapshot> _userCookiesSubscription;

  bool _isListening = false;

  @override
  void initState() {
    super.initState();

    getFirebaseMessagingToken();
    NotificationService.requireUserNotificationPermissions(context)
        .then((isAllowed) => updateNotificationsPermission(isAllowed));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final UserModel? currentUser = Provider.of<UserModel>(context);
    print('CookiePage didChangeDependencies() _isListening: $_isListening');
    // if (currentUser != null && !_isListening) {
    //   _allCookiesSubscription =
    //       DataRepository(uid: currentUser.uid).listenForAllCookieUpdates();
    //   // _userCookiesSubscription =
    //   //     DataRepository(uid: currentUser.uid).listenForUserCookieUpdates();
    //   _isListening = true;
    // }
  }

  @override
  dispose() {
    print('CookiePage dispose()');
    //_allCookiesSubscription.cancel();
    //_userCookiesSubscription.cancel();
    super.dispose();
  }

  // If the widget was removed from the tree while the asynchronous platform
  // message was in flight, we want to discard the reply rather than calling
  // setState to update our non-existent appearance.
  setSafeState(Function execution) {
    if (!mounted) {
      execution();
    } else {
      setState(() {
        execution();
      });
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getFirebaseMessagingToken() async {
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      NotificationService().addListener(() {
        setSafeState(() {});
      });
      try {
        await AwesomeNotificationsFcm().requestFirebaseAppToken();
      } catch (exception) {
        debugPrint('$exception');
      }
    } else {
      setSafeState(() {});
      debugPrint('Firebase is not available on this project');
    }
  }

  void updateNotificationsPermission(bool isAllowed) {
    setSafeState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AwesomeNotifications().isNotificationAllowed().then((bool isAllowed) {
        updateNotificationsPermission(isAllowed);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? currentUser = Provider.of<UserModel>(context);

    return StreamProvider<UserDataModel?>.value(
      value: DataRepository(uid: currentUser!.uid).userDataModel,
      initialData: null,
      catchError: (_, __) => UserDataModel.defaultUser,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text(
            'MyCrumbl',
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const InfoPage(),
                  ),
                );
              },
              icon: Icon(Icons.info_outline_rounded,
                  color: Theme.of(context).colorScheme.primary),
            ),
            IconButton(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.logout,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
        body: Consumer<UserDataModel?>(
          builder:
              (BuildContext context, UserDataModel? userData, Widget? child) {
            if (userData == null) {
              return const Center(
                child: LoadingPage(),
              );
            }
            return CookieList(index: userData.defaultView ?? 'all');
          },
        ),
      ),
    );
  }
}
