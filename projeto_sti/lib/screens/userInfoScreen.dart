import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projeto_sti/api/users.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/inputField.dart';
import 'package:projeto_sti/components/inputFieldLabel.dart';
import 'package:projeto_sti/components/popupMessage.dart';
import 'package:projeto_sti/models/user.dart';
import 'package:projeto_sti/screens/chooseGenresScreen.dart';
import 'package:projeto_sti/styles/style.dart';

import 'package:image_picker/image_picker.dart';
import 'package:projeto_sti/validators.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoState();
}

enum Gender { none, female, male, nonBynary, preferNotSay, other }

class _UserInfoState extends State<UserInfoScreen> {
  late XFile? imageFile = null;
  final ImagePicker _picker = ImagePicker();

  final GlobalKey<FormState> _userInfoFormKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();

  Gender? _gender = Gender.none;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (Navigator.of(context).userGestureInProgress) {
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Styles.colors.background,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: const [
                    AppLogo(),
                  ],
                ),
                Form(
                  key: _userInfoFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Center(
                          child: Text(
                            "Tell us about yourself...",
                            textAlign: TextAlign.center,
                            style: Styles.fonts.title,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: InputFieldLabel(text: "Photo"),
                      ),
                      GestureDetector(
                        onTap: () => _onImageButtonPressed(),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Styles.colors.lightBlue,
                                radius: 38.0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: imageFile == null
                                      ? null
                                      //: Image.file(File(imageFile!.path)).image,
                                      : Image.file(File(imageFile!.path)).image,
                                  radius: 34.0,
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Styles.colors.darker,
                                radius: 34.0,
                              ),
                              const Icon(Icons.file_upload_outlined,
                                  color: Colors.white, size: 40),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      InputField(
                        label: "Name",
                        hintText: "Enter your name",
                        validator: nameValidator,
                        controller: _name,
                        onFieldSubmitted: (value) {
                          tryAddUser(context);
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: InputFieldLabel(text: "Gender"),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildGender(Gender.female),
                                _buildGender(Gender.male),
                                _buildGender(Gender.nonBynary),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildGender(Gender.preferNotSay),
                                  _buildGender(Gender.other),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      InputField(
                        label: "Age",
                        hintText: "Enter your age",
                        validator: ageValidator,
                        controller: _age,
                        onFieldSubmitted: (value) {
                          tryAddUser(context);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 60.0, left: 60.0, bottom: 10.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            primary: Styles.colors.button,
                            minimumSize: const Size(300, 50),
                          ),
                          onPressed: () {
                            tryAddUser(context);
                          },
                          child: Text(
                            'Next',
                            style: Styles.fonts.button,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void tryAddUser(BuildContext context) async {
    if (_userInfoFormKey.currentState!.validate()) {
      if (_gender == Gender.none) {
        showPopupMessage(context, "error", "Choose your gender!", false);
      } else if (imageFile == null) {
        showPopupMessage(context, "error", "Upload your photo!", false);
      } else {
        UserAPI().addUser(
            UserModel(
                id: "",
                name: _name.text,
                gender: _gender.toString(),
                age: int.parse(_age.text),
                imageDownloadUrl: "",
                authId: "",
                genrePreferences: {},
                favouriteMovies: [],
                favouriteTvShows: [],
                watchedMovies: [],
                watchedTvShows: []),
            imageFile!);
        await UserAPI().setLoggedInUser();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const ChooseGenresScreen()));
      }
    }
  }

  GestureDetector _buildGender(Gender gender) {
    Stack stack = Stack();
    if (gender == Gender.nonBynary) {
      stack = Stack(
        alignment: Alignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 27.0,
          ),
          CircleAvatar(
            backgroundColor: (_gender == Gender.none || _gender != gender)
                ? Styles.colors.darker
                : Styles.colors.greenButton,
            radius: 26.0,
          ),
          Column(
            children: [
              Text("Non", style: Styles.fonts.edit),
              Text("Binary", style: Styles.fonts.edit),
            ],
          ),
        ],
      );
    } else if (gender == Gender.female || gender == Gender.male) {
      stack = Stack(
        alignment: Alignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 27.0,
          ),
          CircleAvatar(
            backgroundColor: (_gender == Gender.none || _gender != gender)
                ? Styles.colors.darker
                : (gender == Gender.female
                    ? Styles.colors.female
                    : Styles.colors.male),
            radius: 26.0,
          ),
          Icon(gender == Gender.female ? Icons.female : Icons.male,
              color: Colors.white, size: 40),
        ],
      );
    } else if (gender == Gender.preferNotSay) {
      stack = Stack(
        alignment: Alignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 27.0,
          ),
          CircleAvatar(
            backgroundColor: (_gender == Gender.none || _gender != gender)
                ? Styles.colors.darker
                : Colors.indigo,
            radius: 26.0,
          ),
          Column(
            children: [
              Text("Prefer", style: Styles.fonts.edit),
              Text("not say", style: Styles.fonts.edit),
            ],
          ),
        ],
      );
    } else if (gender == Gender.other) {
      stack = Stack(
        alignment: Alignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 27.0,
          ),
          CircleAvatar(
            backgroundColor: (_gender == Gender.none || _gender != gender)
                ? Styles.colors.darker
                : Colors.orangeAccent,
            radius: 26.0,
          ),
          Text("Other", style: Styles.fonts.edit),
        ],
      );
    }

    return GestureDetector(
      onTap: () {
        setState(
          () {
            if (_gender != gender) {
              _gender = gender;
            } else {
              _gender = Gender.none;
            }
          },
        );
      },
      child: stack,
    );
  }

  Future<void> _onImageButtonPressed() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        maxWidth: 1200,
        maxHeight: 1200,
        source: ImageSource.gallery,
      );
      setState(() {
        if (pickedFile != null) imageFile = pickedFile;
      });
    } catch (e) {
      print("ERROR");
    }
  }
}
