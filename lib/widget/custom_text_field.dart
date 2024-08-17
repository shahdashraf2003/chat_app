import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  CustomTextFormField({
    super.key,
    this.hintText,
    this.onChanged,
    required this.obscureText,
  });
  Function(String)? onChanged;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      validator: (value) {
        if (value!.isEmpty) {
          return 'required field';
        }
        return null;
      },
      onChanged: onChanged,
      style: const TextStyle(
        color: Color(0xffe5e5e5),
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        fillColor: const Color(0xffe5e5e5),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: const BorderSide(
            color: Color(0xffe5e5e5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: const BorderSide(
            color: Color(0xffe5e5e5),
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xffe5e5e5),
        ),
      ),
    );
  }
}
