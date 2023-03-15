import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:my_crumbl/services/auth_service.dart';
import 'package:my_crumbl/shared/auth_exception_handler.dart';
import 'package:my_crumbl/shared/colors.dart';
import 'package:my_crumbl/shared/my_crumbl_text_form_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String _msg = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 50.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Image.asset(
                      'assets/images/logo-slogan-no-background.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  const Text(
                    'Enter your email to reset your password',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  MyCrumblTextFormField(
                      controller: _emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      prefixIcon: const Icon(Icons.email),
                      validator: (val) => EmailValidator.validate(val!)
                          ? null
                          : 'Please enter a valid email'),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: CrumblColors.primary,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final result = await _auth.sendPasswordResetEmail(
                              _emailController.text.trim());
                          if (result != AuthResultStatus.successful) {
                            _msg =
                                AuthExceptionHandler.generateExceptionMessage(
                                    result);
                          }
                          _showAlertDialog(_msg);
                        }
                      },
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'This app is not affiliated with Crumbl™ Cookies',
              textAlign: TextAlign.end,
              style: TextStyle(color: CrumblColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  _showAlertDialog(msg) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            msg.isEmpty ? 'Password Reset Email has been Sent' : 'Login Failed',
            style: const TextStyle(color: Colors.black),
          ),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                popTwice(context);
                _emailController.clear();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                    color: CrumblColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
      barrierDismissible: true,
    );
  }

  void popTwice(context) {
    var count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == 2;
    });
  }
}
