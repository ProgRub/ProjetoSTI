import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputFormWidget extends StatelessWidget {
  final String? description;
  final ValueChanged<String> onChangedDescription;

  const InputFormWidget(
      {Key? key, this.description = "", required this.onChangedDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;

    return Container(
      width: we * 8,
      height: he * 0.49,
      margin: EdgeInsets.only(top: he * 0.3, left: we * 0.1),
      child: TextFormField(
        // initialValue: widget.note?.description,
        initialValue: description,
        onChanged: onChangedDescription,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: 'Enter your name',
          hintStyle: GoogleFonts.lato(
              color: Colors.black.withOpacity(0.3), fontSize: 27),
        ),
        style: GoogleFonts.lato(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
      ),
    );
  }
}
