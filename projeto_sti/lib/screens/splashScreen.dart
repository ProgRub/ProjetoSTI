import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projeto_sti/screens/chooseGenresScreen.dart';
import 'package:projeto_sti/screens/loginScreen.dart';
import 'package:projeto_sti/screens/mainScreen.dart';
import 'package:projeto_sti/styles/style.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 1),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const ChooseGenresScreen())));
  }

  @override
  Widget build(BuildContext context) {
    var appName = Text.rich(
      TextSpan(
        text: "POP",
        style: GoogleFonts.openSans(
          fontSize: 55,
          fontWeight: FontWeight.w900,
          color: const Color.fromRGBO(47, 253, 246, 1),
        ),
        children: <TextSpan>[
          TextSpan(
            text: "CORN",
            style: GoogleFonts.openSans(
              fontSize: 55,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Styles.colors.background,
      body: InkWell(
        child: Container(
          color: Styles.colors.background,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              appName,
              const SizedBox(
                height: 40.0,
              ),
              Image.asset("packages/projeto_sti/assets/images/film-popcorn.gif",
                  width: 100, height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
