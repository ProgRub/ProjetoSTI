import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_sti/components/inputField.dart';
import 'package:projeto_sti/components/popupMessage.dart';
import 'package:projeto_sti/screens/chooseGenresScreen.dart';
import 'package:projeto_sti/styles/style.dart';
import 'package:projeto_sti/validators.dart';

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
                if (_signUpFormKey.currentState!.validate()) {
                  showPopupMessageWithFunction(
                      context, "success", "Your account has been created!", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChooseGenresScreen(),
                      ),
                    );
                  });
                }
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

  String? confirmPasswordValidator(String? value) {
    if (inputIsEmptyOrNull(value)) {
      return 'Please enter your password';
    } else if (value != _password.text) {
      return "Password mismatch";
    }
    return null;
  }
}
