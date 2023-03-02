import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_crumbl/pages/authenticate/login_or_register_page.dart';
import 'package:my_crumbl/pages/home/cookie_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const CookiePage();
          } else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
