import 'package:flutter/material.dart';

void showTextDialog({
  required BuildContext context,
  required String title,
  required bool isPassword,
  required Function(String) onSubmitted,
}) {
  final textController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        obscureText: isPassword,
        autofocus: true,
        controller: textController,
      ),
      actions: [
        TextButton(
          child: const Text('Abbrechen'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            onSubmitted(textController.text);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
