import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static final colors = _Colors();
  static final fonts = _TextStyle();
}

class _Colors {
  final background = const Color.fromRGBO(18, 18, 18, 1);
  final purple = const Color.fromRGBO(187, 134, 252, 1);
  final button = const Color.fromRGBO(55, 0, 179, 1);
  final grey = Colors.white.withOpacity(0.25);
  final error = const Color.fromARGB(255, 101, 5, 0);
  final errorText = const Color.fromARGB(255, 245, 140, 133);
  final successText = const Color.fromARGB(255, 173, 247, 176);
}

class _TextStyle {
  final title = GoogleFonts.lato(
    fontSize: 25,
    color: Colors.white,
    fontWeight: FontWeight.w900,
  );
  final label = GoogleFonts.lato(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );
  final button = GoogleFonts.lato(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.w900,
  );
}
