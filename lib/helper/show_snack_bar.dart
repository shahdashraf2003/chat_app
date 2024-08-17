import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.all(50),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color.fromARGB(255, 242, 0, 81),
        content: Text(message),
      ),
    );
  }