import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_sti/screens/mainScreen.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          )),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 0.0),
        child: RichText(
          text: TextSpan(
            text: "P",
            style: GoogleFonts.openSans(
              fontSize: 55,
              fontWeight: FontWeight.w900,
              color: const Color.fromRGBO(47, 253, 246, 1),
            ),
            children: <TextSpan>[
              TextSpan(
                text: "C",
                style: GoogleFonts.openSans(
                  fontSize: 55,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
