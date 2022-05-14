import 'package:flutter/material.dart';
import 'package:projeto_sti/animation/fadeAnimation.dart';
import 'package:projeto_sti/components/passwordForm.dart';
import 'package:projeto_sti/components/popupMessage.dart';
import 'package:projeto_sti/styles/style.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordScreen> {
  late String password;
  late String confirmPassword;

  @override
  void initState() {
    password = "";
    confirmPassword = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Styles.colors.background,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check, size: 30.0),
        backgroundColor: Styles.colors.purple,
        onPressed: editPassword,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeAnimation(
                delay: 0.2,
                child: Container(
                  margin: EdgeInsets.only(top: he * 0.05, left: we * 0.73),
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.grey[300], shape: BoxShape.circle),
                  child: Container(
                    width: 47,
                    height: 47,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffF4F6FD),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 90.0),
              Text("New Password", style: Styles.fonts.title),
              FadeAnimation(
                delay: 0.3,
                child: PasswordFormWidget(
                  description: "",
                  onChangedDescription: (password) {
                    setState(() => this.password = password);
                  },
                ),
              ),
              const SizedBox(height: 50.0),
              Text("Confirm Password", style: Styles.fonts.title),
              FadeAnimation(
                delay: 0.3,
                child: PasswordFormWidget(
                  description: "",
                  onChangedDescription: (confirmPassword) {
                    setState(() => this.confirmPassword = confirmPassword);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future editPassword() async {
    if (!password.isNotEmpty) {
      showPopupMessage(context, "error", "Please, enter your new password!");
    } else if (!confirmPassword.isNotEmpty) {
      showPopupMessage(context, "error", "Please, confirm your password!");
    } else if (password != confirmPassword) {
      showPopupMessage(context, "error", "Password mismatch!");
    } else {
      Navigator.of(context).pop(password);
    }
  }
}
