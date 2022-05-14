import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordFormWidget extends StatelessWidget {
  final String? description;
  final ValueChanged<String> onChangedDescription;

  const PasswordFormWidget(
      {Key? key, this.description = "", required this.onChangedDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;

    return Container(
      width: we * 8,
      margin: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        initialValue: description,
        onChanged: onChangedDescription,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: 'Enter your password',
          hintStyle: GoogleFonts.lato(color: Colors.grey, fontSize: 22),
        ),
        style: GoogleFonts.lato(
            color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 22),
      ),
    );
  }
}
