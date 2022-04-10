import 'package:flutter/material.dart';
import 'package:projeto_sti/styles/style.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;

  const InputField(
      {required this.controller,
      required this.hintText,
      required this.validator,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 60,
        left: 60,
      ),
      child: SizedBox(
        height: 85,
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: hintText.contains("email")
              ? TextInputType.emailAddress
              : TextInputType.multiline,
          obscureText: !hintText.contains("email"),
          enableSuggestions: hintText.contains("email"),
          autocorrect: hintText.contains("email"),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: Styles.colors.lightBlue, width: 1.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: Styles.colors.lightBlue, width: 1.0),
            ),
            errorStyle: const TextStyle(fontSize: 13.0),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            hintText: hintText,
            hintStyle: Styles.fonts.placeholder,
          ),
          validator: validator,
        ),
      ),
    );
  }
}
