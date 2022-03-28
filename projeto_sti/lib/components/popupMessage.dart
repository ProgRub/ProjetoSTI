import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopupMessage extends StatelessWidget {
  final String type;
  final String message;

  const PopupMessage({
    required this.type,
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: popupColor(),
        title: Center(
          child: Text(
            message,
            style: GoogleFonts.roboto(
              fontSize: 18,
              color: type == "error"
                  ? const Color.fromARGB(255, 101, 5, 0)
                  : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        content: type == "error"
            ? const Icon(Icons.error_outline,
                size: 40.0, color: Color.fromARGB(255, 101, 5, 0))
            : const Icon(Icons.check_circle, size: 40.0));
  }

  Color popupColor() {
    switch (type) {
      case "error":
        return const Color.fromARGB(255, 245, 140, 133);
      case "success":
        return const Color.fromARGB(255, 173, 247, 176);
      default:
        return Colors.white;
    }
  }
}

void showPopupMessage(BuildContext context, String type, String message) {
  late Timer _timer;
  showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        _timer = Timer(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });

        return PopupMessage(type: type, message: message);
      }).then((val) {
    if (_timer.isActive) {
      _timer.cancel();
    }
  });
}
