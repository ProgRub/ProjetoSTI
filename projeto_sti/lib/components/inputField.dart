import 'package:flutter/material.dart';
import 'package:projeto_sti/styles/style.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;
  final String label;
  final Function(String)? onFieldSubmitted;

  InputField(
      {required this.controller,
      required this.hintText,
      required this.validator,
      required this.label,
      required this.onFieldSubmitted,
      Key? key})
      : super(key: key);

  TextInputType _inputType() {
    if (hintText.contains("email")) {
      return TextInputType.emailAddress;
    } else if (hintText.contains("name")) {
      return TextInputType.name;
    } else if (hintText.contains("age")) {
      return TextInputType.number;
    }
    return TextInputType.text;
    // else if (hintText.contains("password")) {
    //   return TextInputType.multiline;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 60,
        left: 60,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Styles.fonts.label,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 82,
            width: 300,
            child: TextFormField(
              controller: controller,
              onFieldSubmitted: onFieldSubmitted,
              textAlign: TextAlign.center,
              keyboardType: _inputType(),
              obscureText: hintText.contains("password"),
              enableSuggestions: !hintText.contains("password"),
              autocorrect: !hintText.contains("password"),
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
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                hintText: hintText,
                hintStyle: Styles.fonts.placeholder,
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}
