import 'package:flutter/material.dart';

import 'dart:async';

class ScaffoldMessengerController {
  final BuildContext context;
  final Duration displayDuration;
  Timer? _timer;

  ScaffoldMessengerController({
    required this.context,
    required this.displayDuration,
  });

  void showMessage(String message) {
    _timer?.cancel();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), duration: displayDuration));

    _timer = Timer(displayDuration, () {
      _timer = null;
    });
  }
}
