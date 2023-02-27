import 'package:flutter/material.dart';
import 'package:my_crumbl/services/auth_service.dart';
import 'package:my_crumbl/shared/colors.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final AuthService _auth = AuthService();

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
          style: TextStyle(color: CrumblColors.primary),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: const Icon(Icons.logout, color: CrumblColors.primary),
          ),
        ],
      ),
    );
  }
}
