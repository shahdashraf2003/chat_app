import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Button extends StatelessWidget {
  Button({
    super.key,
    required this.buttonText,
     this.onPressed,
  });
  final String buttonText;

  VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: const Color(0xffe5e5e5),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xfff63a79),
          ),
        ),
      ),
    );
  }
}
