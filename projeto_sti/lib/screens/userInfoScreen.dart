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

enum Gender { none, female, male }

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
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Styles.colors.background,
        body: Stack(
          children: [
            const AppLogo(),
            Form(
              key: _userInfoFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 70.0),
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
                                  : Image.network(imageFile!.path).image,
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
                  InputField(
                    label: "Name",
                    hintText: "Enter your name",
                    validator: nameValidator,
                    controller: _name,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: InputFieldLabel(text: "Gender"),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildGender(Gender.female),
                        _buildGender(Gender.male),
                      ]),
                  InputField(
                    label: "Age",
                    hintText: "Enter your age",
                    validator: ageValidator,
                    controller: _age,
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
                        if (_userInfoFormKey.currentState!.validate()) {
                          if (_gender == Gender.none) {
                            showPopupMessage(
                                context, "error", "Choose your gender!");
                          } else if (imageFile == null) {
                            showPopupMessage(
                                context, "error", "Upload your photo!");
                          } else {
                            UserAPI().addUser(
                                User(
                                    id: "",
                                    name: _name.text,
                                    gender: _gender.toString(),
                                    age: int.parse(_age.text),
                                    imageDownloadUrl: "",
                                    authId: "",
                                    genrePreferences: {},
                                    favouriteMovies: {},
                                    favouriteTvShows: {},
                                    watchedMovies: {},
                                    watchedTvShows: {}),
                                imageFile!);
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const ChooseGenresScreen()));
                          }
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
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildGender(Gender gender) {
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 25.0,
          ),
          CircleAvatar(
            backgroundColor: (_gender == Gender.none || _gender != gender)
                ? Styles.colors.darker
                : (gender == Gender.female
                    ? Styles.colors.female
                    : Styles.colors.male),
            radius: 23.0,
          ),
          Icon(gender == Gender.female ? Icons.female : Icons.male,
              color: Colors.white, size: 40),
        ],
      ),
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
