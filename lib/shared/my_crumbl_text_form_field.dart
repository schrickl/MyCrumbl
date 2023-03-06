import 'package:flutter/material.dart';
import 'package:my_crumbl/shared/colors.dart';

class MyCrumblTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget suffixIcon;
  final int errorMaxLines;
  final TextInputType? keyboardType;
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
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        errorMaxLines: errorMaxLines,
        hintText: hintText,
        hintStyle: const TextStyle(color: CrumblColors.primary),
        prefixIcon: prefixIcon,
        prefixIconColor: CrumblColors.primary,
        suffixIcon: suffixIcon,
        suffixIconColor: CrumblColors.primary,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: CrumblColors.primary),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: CrumblColors.secondary),
        ),
        filled: true,
        fillColor: Colors.white54,
      ),
    );
  }
}
