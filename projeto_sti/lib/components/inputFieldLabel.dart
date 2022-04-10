import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_sti/styles/style.dart';

class InputFieldLabel extends StatelessWidget {
  final String text;

  const InputFieldLabel({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 60.0),
          child: Text(
            text,
            style: Styles.fonts.label,
          ),
        ),
      ],
    );
  }
}
