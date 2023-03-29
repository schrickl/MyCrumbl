import 'package:flutter/material.dart';

class MyCrumblTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget suffixIcon;
  final int errorMaxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;

  const MyCrumblTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.validator,
    required this.prefixIcon,
    this.suffixIcon = const SizedBox(),
    this.errorMaxLines = 1,
    required this.keyboardType,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      textInputAction: textInputAction,
      validator: validator,
      decoration: InputDecoration(
        errorMaxLines: errorMaxLines,
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        prefixIcon: prefixIcon,
        prefixIconColor: Theme.of(context).colorScheme.primary,
        suffixIcon: suffixIcon,
        suffixIconColor: Theme.of(context).colorScheme.primary,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        filled: true,
        fillColor: Colors.white54,
      ),
    );
  }
}
