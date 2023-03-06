import 'package:flutter/material.dart';
import 'package:my_crumbl/pages/authenticate/login_page.dart';
import 'package:my_crumbl/pages/authenticate/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool showLoginPage = true;

  void toggleBetweenLoginAndRegister() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: toggleBetweenLoginAndRegister);
    } else {
      return RegisterPage(onTap: toggleBetweenLoginAndRegister);
    }
  }
}
