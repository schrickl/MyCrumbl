import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:my_crumbl/pages/reset_password_page.dart';
import 'package:my_crumbl/services/auth_service.dart';
import 'package:my_crumbl/shared/auth_exception_handler.dart';
import 'package:my_crumbl/shared/colors.dart';
import 'package:my_crumbl/shared/loading_page.dart';
import 'package:my_crumbl/shared/my_crumbl_text_form_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _error = '';
  bool _isPasswordHidden = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingPage()
        : Scaffold(
            backgroundColor: Colors.grey[50],
            body: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
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
                        MyCrumblTextFormField(
                            controller: _emailController,
                            hintText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            prefixIcon: const Icon(Icons.email),
                            textInputAction: TextInputAction.next,
                            validator: (val) => EmailValidator.validate(val!)
                                ? null
                                : 'Please enter a valid email'),
                        const SizedBox(height: 10.0),
                        MyCrumblTextFormField(
                          controller: _passwordController,
                          errorMaxLines: 2,
                          hintText: 'Password',
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _isPasswordHidden,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: CrumblColors.primary,
                            ),
                            onPressed: togglePasswordVisibility,
                          ),
                          textInputAction: TextInputAction.done,
                          validator: (val) => val!.length < 6 || val.length > 20
                              ? 'Password must be between 6 and 20 characters'
                              : null,
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ResetPasswordPage(),
                                ),
                              ),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: CrumblColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                                setState(() {
                                  _isLoading = true;
                                });
                                final result =
                                    await _auth.signInWithEmailAndPassword(
                                        _emailController.text.trim(),
                                        _passwordController.text.trim());
                                if (result != AuthResultStatus.successful) {
                                  setState(() {
                                    _isLoading = false;
                                    _error = AuthExceptionHandler
                                        .generateExceptionMessage(result);
                                  });
                                  _showAlertDialog(_error);
                                }
                              }
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Not a member?',
                              style: TextStyle(color: CrumblColors.primary),
                            ),
                            const SizedBox(width: 4.0),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: const Text(
                                'Register now',
                                style: TextStyle(
                                  color: CrumblColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
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

  _showAlertDialog(errorMsg) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Login Failed',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(errorMsg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _emailController.clear();
                _passwordController.clear();
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
}
