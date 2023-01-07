import 'package:flutter/material.dart';

class NotificationService {
  static GlobalKey<ScaffoldMessengerState> messageKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
      style: const TextStyle(color: Colors.white, fontSize: 20),
    ));

    messageKey.currentState!.showSnackBar(snackBar);
  }
}
