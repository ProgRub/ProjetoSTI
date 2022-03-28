import 'package:flutter/material.dart';

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
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromRGBO(47, 253, 246, 1), width: 3.0),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 3.0),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromRGBO(47, 253, 246, 1), width: 3.0),
            ),
            errorStyle: const TextStyle(fontSize: 13.0),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            hintText: hintText,
          ),
          validator: validator,
        ),
      ),
    );
  }
}
