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
  final darker = Colors.black.withOpacity(0.40);
  final backgroundDarker = Colors.black.withOpacity(0.85);
  final error = const Color.fromARGB(255, 101, 5, 0);
  final errorText = const Color.fromARGB(255, 245, 140, 133);
  final successText = const Color.fromARGB(255, 173, 247, 176);
  final lightBlue = const Color.fromRGBO(47, 253, 246, 1);
  final female = const Color.fromARGB(255, 233, 137, 255);
  final male = const Color.fromARGB(255, 113, 205, 245);
  final logout = const Color.fromARGB(255, 142, 7, 0);
  final blurred = Colors.black.withOpacity(0.05);
  final genre = const Color.fromARGB(255, 12, 12, 12);
  final watched = const Color.fromARGB(255, 96, 201, 100);
  final greenButton = const Color.fromRGBO(1, 161, 156, 100);
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
  final placeholder = GoogleFonts.lato(
    fontSize: 16,
    color: Colors.grey,
    fontWeight: FontWeight.w400,
  );
  final edit = GoogleFonts.lato(
    fontSize: 13,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );
  final logout = GoogleFonts.lato(
    fontSize: 13,
    color: Styles.colors.logout,
    fontWeight: FontWeight.w500,
  );
  final genre = GoogleFonts.lato(
    fontSize: 15,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  final rating = GoogleFonts.lato(
    fontSize: 15,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );

  final plot = GoogleFonts.lato(
    fontSize: 16,
    color: Colors.grey,
    fontWeight: FontWeight.w400,
  );

  final comment = GoogleFonts.lato(
    fontSize: 14,
    color: Colors.grey,
    fontWeight: FontWeight.w400,
  );

  final commentName = GoogleFonts.lato(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  final hintText = GoogleFonts.lato(
    fontSize: 16,
    color: Colors.grey,
    fontWeight: FontWeight.w600,
  );

  final userName = GoogleFonts.lato(
    fontSize: 23,
    color: Colors.grey,
    fontWeight: FontWeight.w700,
  );

  final genreButton = GoogleFonts.lato(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.w900,
  );

  final reset = GoogleFonts.lato(
    fontSize: 18,
    color: Colors.grey,
    fontWeight: FontWeight.w500,
  );
}
