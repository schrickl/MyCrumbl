import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:my_crumbl/services/auth_service.dart';
import 'package:my_crumbl/shared/auth_exception_handler.dart';
import 'package:my_crumbl/shared/colors.dart';
import 'package:my_crumbl/shared/loading.dart';
import 'package:my_crumbl/shared/my_crumbl_text_form_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _error = '';
  bool _isPasswordHidden = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
        ? const Loading()
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
                            validator: (val) => EmailValidator.validate(val!)
                                ? null
                                : "Please enter a valid email"),
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
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: togglePasswordVisibility,
                          ),
                          validator: (val) => val!.length < 6 || val.length > 20
                              ? 'Password must be between 6 and 20 characters'
                              : null,
                        ),
                        const SizedBox(height: 10.0),
                        MyCrumblTextFormField(
                          controller: _confirmPasswordController,
                          errorMaxLines: 2,
                          hintText: 'Confirm Password',
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _isPasswordHidden,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: togglePasswordVisibility,
                          ),
                          validator: (val) => val != _passwordController.text
                              ? 'Passwords do not match'
                              : null,
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
                                    await _auth.registerWithEmailAndPassword(
                                        _emailController.text.trim(),
                                        _passwordController.text.trim());
                                if (result != AuthResultStatus.successful) {
                                  setState(() {
                                    _error = AuthExceptionHandler
                                        .generateExceptionMessage(result);
                                    _isLoading = false;
                                  });
                                  _showAlertDialog(_error);
                                }
                              }
                            },
                            child: const Text('Register'),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account?',
                              style: TextStyle(color: CrumblColors.primary),
                            ),
                            const SizedBox(width: 4.0),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: const Text(
                                'Login now',
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
            'Registration Failed',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(errorMsg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _emailController.clear();
                _passwordController.clear();
                _confirmPasswordController.clear();
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
