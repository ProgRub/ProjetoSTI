import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_sti/components/inputField.dart';
import 'package:projeto_sti/components/popupMessage.dart';
import 'package:projeto_sti/screens/chooseGenresScreen.dart';

import '../components/appLogo.dart';
import '../components/inputFieldLabel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: InputFieldLabel(
              text: "Email",
            ),
          ),
          InputField(
              hintText: "Enter your email",
              validator: emailValidator,
              controller: _email),
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: InputFieldLabel(
              text: "Password",
            ),
          ),
          InputField(
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
                primary: const Color.fromRGBO(55, 0, 179, 1),
                minimumSize: const Size(300, 50),
              ),
              onPressed: () {
                if (_loginFormKey.currentState!.validate()) {
                  if (userExists(_email.text, _password.text)) {
                    showPopupMessage(
                        context, "success", "Successfully logged in!");
                  } else {
                    showPopupMessage(context, "error", "Invalid credentials");
                  }
                }
              },
              child: Text(
                'Login',
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
    );

    //SignUpSection
    Form signUpPage = Form(
      key: _signUpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: InputFieldLabel(
              text: "Email",
            ),
          ),
          InputField(
              hintText: "Enter your email",
              validator: emailValidator,
              controller: _email),
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: InputFieldLabel(
              text: "Password",
            ),
          ),
          InputField(
              hintText: "Enter your password",
              validator: passwordValidator,
              controller: _password),
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: InputFieldLabel(
              text: "Confirm password",
            ),
          ),
          InputField(
              hintText: "Enter your password",
              validator: confirmPasswordValidator,
              controller: _confirmPass),
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              right: 60.0,
              left: 60.0,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(55, 0, 179, 1),
                minimumSize: const Size(300, 50),
              ),
              onPressed: () {
                if (_signUpFormKey.currentState!.validate()) {
                  showPopupMessageWithFunction(
                      context, "success", "Your account has been created!", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChooseGenresScreen()));
                  });
                }
              },
              child: Text(
                'Next',
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
                        ? const Color.fromRGBO(187, 134, 252, 1)
                        : Colors.white.withOpacity(0.25))),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: 6,
                width: 90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: index == selectedCategory
                        ? const Color.fromRGBO(187, 134, 252, 1)
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
          ),
        ],
      ),
    );
  }

  String? confirmPasswordValidator(String? value) {
    if (inputIsEmptyOrNull(value)) {
      return 'Please enter your password';
    } else if (value != _password.text) {
      return "Password mismatch";
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (inputIsEmptyOrNull(value)) {
      return 'Please enter your password';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (inputIsEmptyOrNull(value)) {
      return 'Please enter an email';
    } else if (!isValidEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
}

//JUST FOR TESTING!!!
bool userExists(email, password) =>
    email == "test@test.com" && password == "test";

bool inputIsEmptyOrNull(value) => value == null || value.isEmpty;

bool isValidEmail(email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}
