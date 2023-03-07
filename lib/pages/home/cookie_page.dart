import 'package:flutter/material.dart';
import 'package:my_crumbl/pages/home/cookie_list.dart';
import 'package:my_crumbl/services/auth_service.dart';
import 'package:my_crumbl/services/firestore_service.dart';
import 'package:my_crumbl/shared/colors.dart';

class CookiePage extends StatefulWidget {
  const CookiePage({super.key});

  @override
  State<CookiePage> createState() => _CookiePageState();
}

class _CookiePageState extends State<CookiePage> {
  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CrumblColors.secondary,
      appBar: AppBar(
        backgroundColor: CrumblColors.accentColor,
        centerTitle: true,
        elevation: 0.0,
        title: const Text(
          'MyCrumbl',
          style: TextStyle(
              color: CrumblColors.bright1,
              fontWeight: FontWeight.bold,
              fontSize: 30),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {},
            icon: const Icon(Icons.settings, color: CrumblColors.bright1),
          ),
          IconButton(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: const Icon(Icons.logout, color: CrumblColors.bright1),
          ),
        ],
      ),
      body: const CookieList(),
    );
  }
}
