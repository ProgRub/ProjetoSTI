import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_sti/api/exceptions.dart';
import 'package:projeto_sti/api/users.dart';
import 'package:projeto_sti/components/inputField.dart';
import 'package:projeto_sti/components/popupMessage.dart';
import 'package:projeto_sti/screens/chooseGenresScreen.dart';
import 'package:projeto_sti/screens/mainScreen.dart';
import 'package:projeto_sti/screens/userInfoScreen.dart';
import 'package:projeto_sti/styles/style.dart';
import 'package:projeto_sti/validators.dart';

import '../api/authentication.dart';
import '../components/appLogo.dart';
import '../components/inputFieldLabel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Authentication authentication = Authentication();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  int selectedCategory = 0;
  final List<String> categories = ["Login", "Sign Up"];

  @override
  Widget build(BuildContext context) {
    //LoginSection
    var loginPage = Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          InputField(
              label: "Email",
              hintText: "Enter your email",
              validator: emailValidator,
              controller: _email),
          InputField(
              label: "Password",
              hintText: "Enter your password",
              validator: passwordValidator,
              controller: _password),
          Padding(
            padding: const EdgeInsets.only(
              top: 30.0,
              right: 60,
              left: 60,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                primary: Styles.colors.button,
                minimumSize: const Size(300, 50),
              ),
              onPressed: () {
                tryLogin(context);
              },
              child: Text(
                'Login',
                style: Styles.fonts.button,
              ),
            ),
          ),
        ],
      ),
    );

    //SignUpSection
    Form signUpPage = Form(
      key: _signUpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InputField(
            label: "Email",
            hintText: "Enter your email",
            validator: emailValidator,
            controller: _email,
          ),
          InputField(
            label: "Password",
            hintText: "Enter your password",
            validator: passwordValidator,
            controller: _password,
          ),
          InputField(
            label: "Confirm password",
            hintText: "Enter your password",
            validator: confirmPasswordValidator,
            controller: _confirmPass,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              right: 60.0,
              left: 60.0,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                primary: Styles.colors.button,
                minimumSize: const Size(300, 50),
              ),
              onPressed: () {
                trySignUp(context);
              },
              child: Text(
                'Next',
                style: Styles.fonts.button,
              ),
            ),
          ),
        ],
      ),
    );

    //Method to create a tab
    GestureDetector createTab(index, context) {
      return GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(categories[index],
                style: GoogleFonts.roboto(
                    fontSize: 33,
                    fontWeight: FontWeight.w900,
                    color: index == selectedCategory
                        ? Styles.colors.purple
                        : Styles.colors.grey)),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: 6,
                width: 90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: index == selectedCategory
                        ? Styles.colors.purple
                        : Colors.transparent))
          ],
        ),
        onTap: () {
          setState(
            () {
              selectedCategory = index;
            },
          );
        },
      );
    }

    //Login and Sign Up Tabs
    Container tabs = Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 70,
      child: Center(
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) => createTab(index, context),
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              width: 30,
            );
          },
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Styles.colors.background,
        body: Stack(
          children: [
            const AppLogo(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tabs,
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  firstChild: loginPage,
                  secondChild: signUpPage,
                  crossFadeState: selectedCategory == 0
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void trySignUp(BuildContext context) async {
    try {
      await authentication.signUserUp(
          _email.text, _password.text, _confirmPass.text);
      showPopupMessageWithFunction(
          context, "success", "Your account has been created!", () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserInfoScreen(),
          ),
        );
      });
    } on SignUpException catch (e) {
      String message = "";
      switch (e.code) {
        case "empty-email":
          message = "No email provided.";
          break;
        case "empty-password":
          message = "No password provided.";
          break;
        case "empty-password-confirm":
          message = "Please confirm your password.";
          break;
        case "passwords-dont-match":
          message = "Passwords don't match.";
          break;
        case "email-already-in-use":
          message = "That email is already taken.";
          break;
        case "invalid-email":
          message = "Invalid email.";
          break;
        case "operation-not-allowed":
          message = "Please contact the developers.";
          break;
        case "weak-password":
          message = "Password not strong enough.";
          break;
      }
      showPopupMessage(context, "error", message);
    }
  }

  void tryLogin(BuildContext context) async {
    try {
      await authentication.login(_email.text, _password.text);
      var chosenGenres = UserAPI().loggedInUser!.genrePreferences.isNotEmpty;
      // showPopupMessage(context, "success", "Successfully logged in!");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              (chosenGenres ? const MainScreen() : const ChooseGenresScreen()),
        ),
      );
      // Timer(
      //   const Duration(seconds: 3),
      //   () => Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => (chosenGenres
      //           ? const MainScreen()
      //           : const ChooseGenresScreen()),
      //     ),
      //   ),
      // );
    } on LoginException catch (e) {
      String message = "";
      switch (e.code) {
        case "empty-email":
          message = "No email provided.";
          break;
        case "empty-password":
          message = "No password provided.";
          break;
        case "invalid-email":
          message = "Invalid email.";
          break;
        case "user-disabled":
          message = "User account deleted.";
          break;
        case "user-not-found":
          message = "No user found.";
          break;
        case "wrong-password":
          message = "Invalid credentials.";
          break;
      }
      showPopupMessage(context, "error", message);
    }
  }

  String? confirmPasswordValidator(String? value) {
    if (inputIsEmptyOrNull(value)) {
      return 'Please enter your password';
    } else if (value != _password.text) {
      return "Password mismatch";
    }
    return null;
  }
}
