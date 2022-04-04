import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_sti/components/inputField.dart';
import 'package:projeto_sti/components/popupMessage.dart';

import '../components/appLogo.dart';
import '../components/inputFieldLabel.dart';

class ChooseGenresScreen extends StatefulWidget {
  const ChooseGenresScreen({Key? key}) : super(key: key);

  @override
  State<ChooseGenresScreen> createState() => _ChooseGenresState();
}

class _ChooseGenresState extends State<ChooseGenresScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      body: Stack(
        children: [
          const AppLogo(),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 60, right: 60, bottom: 120),
                  child: Text(
                    "Choose three or more of your favourite genres:",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                    right: 60,
                    left: 60,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(55, 0, 179, 1),
                      minimumSize: const Size(300, 50),
                    ),
                    onPressed: () {
                      print("START");
                    },
                    child: Text(
                      "Let's start!",
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                    right: 60,
                    left: 60,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(0, 54, 0, 179),
                      minimumSize: const Size(300, 50),
                    ),
                    onPressed: () {
                      print("RESET");
                    },
                    child: Text(
                      "Reset",
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
