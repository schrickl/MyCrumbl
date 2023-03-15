import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/services/data_repository.dart';
import 'package:provider/provider.dart';

class CookiesProvider extends StatelessWidget {
  final Widget child;

  const CookiesProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    final UserModel? currentUser = Provider.of<UserModel>(context);
    final cookiesStream =
        FirebaseFirestore.instance.collection('cookies').snapshots();
    final user = FirebaseAuth.instance.currentUser;
    final userStream = FirebaseFirestore.instance
        .collection('user_data')
        .doc(currentUser?.uid)
        .snapshots();

    return MultiProvider(
      providers: [
        StreamProvider<UserDataModel?>.value(
          value: DataRepository(uid: currentUser!.uid).userDataModel,
          initialData: null,
          catchError: (_, __) => UserDataModel.defaultUser,
        ),
        StreamProvider<List<CookieModel>>.value(
          value: DataRepository(uid: currentUser.uid).cookies,
          initialData: const [],
          catchError: (_, __) => [],
        ),
      ],
      child: child,
    );
  }
}
