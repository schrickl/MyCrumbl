import 'package:flutter/material.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/pages/authenticate/login_or_register_page.dart';
import 'package:my_crumbl/pages/home/cookie_page.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel? currentUser = Provider.of<UserModel?>(context);

    if (currentUser == null) {
      return const LoginOrRegisterPage();
    } else {
      return const CookiePage();
    }
  }
}
