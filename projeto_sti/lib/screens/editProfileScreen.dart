import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_sti/api/authentication.dart';
import 'package:projeto_sti/api/internetConnection.dart';
import 'package:projeto_sti/api/users.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/bottomAppBar.dart';
import 'package:projeto_sti/components/inputField.dart';
import 'package:projeto_sti/components/inputScreen.dart';
import 'package:projeto_sti/components/popupMessage.dart';
import 'package:projeto_sti/components/quarterCircle.dart';
import 'package:projeto_sti/screens/chooseGenresScreen.dart';
import 'package:projeto_sti/screens/profileScreen.dart';
import 'package:projeto_sti/styles/style.dart';

import 'package:image_picker/image_picker.dart';
import 'package:projeto_sti/validators.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';

import 'dart:developer' as developer;
import 'editPasswordScreen.dart';
import 'loginScreen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileState();
}

enum Gender { none, female, male }

class _EditProfileState extends State<EditProfileScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late XFile? imageFile = null;
  final ImagePicker _picker = ImagePicker();

  final GlobalKey<FormState> _userEditFormKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _age = TextEditingController();

  late String newPassword;
  late List<String> newGenrePreferences;

  @override
  initState() {
    newPassword = "";
    newGenrePreferences = [];
    _name.text = UserAPI().loggedInUser!.name;
    _email.text = Authentication().loggedInUser!.email.toString();
    _age.text = UserAPI().loggedInUser!.age.toString();
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenTitle = Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 30.0, bottom: 20.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Edit Profile",
          style: Styles.fonts.title,
        ),
      ),
    );

    var logoutButton = Stack(
      children: [
        GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ));
            },
            child: _buildQuarterCircle(80, Colors.white)),
        Padding(
          padding: const EdgeInsets.only(top: 20, right: 10),
          child: Align(
            alignment: Alignment.topRight,
            child: Transform.rotate(
              angle: pi / 4,
              child: Text('Cancel', style: Styles.fonts.logout),
            ),
          ),
        ),
      ],
    );
    var uploadPhotoSection = GestureDetector(
      onTap: () => _onImageButtonPressed(),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Styles.colors.lightBlue,
              radius: 50.0,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: imageFile == null
                    ? NetworkImage(UserAPI().loggedInUser!.imageDownloadUrl)
                    : Image.file(File(imageFile!.path)).image,
                radius: 46.0,
              ),
            ),
            CircleAvatar(
              backgroundColor: Styles.colors.darker,
              radius: 46.0,
            ),
            FaIcon(FontAwesomeIcons.userPen,
                size: 26.0, color: Styles.colors.lightBlue),
            const FaIcon(FontAwesomeIcons.userPen,
                size: 24.0, color: Colors.white),
          ],
        ),
      ),
    );

    var nameEdit = GestureDetector(
      onTap: () {
        _navigateAndDisplayChange(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_name.text, style: Styles.fonts.label),
            const SizedBox(
              width: 5.0,
            ),
            const Icon(Icons.edit, size: 28.0, color: Colors.white),
          ],
        ),
      ),
    );

    var emailEdit = InputField(
      label: "Email",
      hintText: "Enter your email",
      validator: emailValidator,
      hasNextField: true,
      controller: _email,
      onFieldSubmitted: (value) {
        trySaveChanges(context);
      },
    );

    var ageEdit = InputField(
        label: "Age",
        hintText: "Enter your age",
        validator: ageValidator,
        hasNextField: false,
        onFieldSubmitted: (value) {
          trySaveChanges(context);
        },
        controller: _age);

    var changePassButton = Padding(
      padding: const EdgeInsets.only(right: 60.0, left: 60.0, bottom: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          primary: Styles.colors.purple,
          minimumSize: const Size(300, 40),
        ),
        onPressed: () => _getPasswordChanged(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.password, size: 25),
            const SizedBox(width: 10),
            Text(
              'Change Password',
              style: Styles.fonts.button,
            ),
          ],
        ),
      ),
    );

    var favGenresButton = Padding(
      padding: const EdgeInsets.only(right: 60.0, left: 60.0, bottom: 50.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          primary: Styles.colors.greenButton,
          minimumSize: const Size(300, 40),
        ),
        onPressed: () {
          _getNewGenrePreferences(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.movie_filter, size: 25),
            const SizedBox(width: 10),
            Text(
              'Favourite Genres ',
              style: Styles.fonts.button,
            )
          ],
        ),
      ),
    );

    var saveChangesButton = Padding(
      padding: const EdgeInsets.only(right: 60.0, left: 60.0, bottom: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          primary: Styles.colors.button,
          minimumSize: const Size(300, 50),
        ),
        onPressed: () {
          trySaveChanges(context);
        },
        child: Text(
          'Save Changes',
          style: Styles.fonts.button,
        ),
      ),
    );

    var deleteAccButton = Padding(
      padding: const EdgeInsets.only(right: 60, left: 60, bottom: 30.0),
      child: TextButton(
        onPressed: () async {
          if (!hasInternet(context, _connectionStatus)) return;

          showPopupMessageWithFunction(context, "error",
              "Are you sure you want to delete your account?", true, () {
            Authentication().deleteUser();
            UserAPI().deleteUser();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          });
        },
        child: Text(
          "Delete Account",
          style: Styles.fonts.reset,
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Styles.colors.background,
        bottomNavigationBar: const AppBarBottom(currentIndex: 4),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  const Align(
                    child: AppLogo(),
                    alignment: Alignment.topLeft,
                  ),
                  logoutButton,
                ],
              ),
              screenTitle,
              Form(
                key: _userEditFormKey,
                child: Column(
                  children: [
                    uploadPhotoSection,
                    nameEdit,
                    emailEdit,
                    ageEdit,
                    changePassButton,
                    favGenresButton,
                    saveChangesButton,
                    deleteAccButton,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void trySaveChanges(BuildContext context) {
    if (!hasInternet(context, _connectionStatus)) return;

    if (_userEditFormKey.currentState!.validate()) {
      bool changedAge = _age.text != UserAPI().loggedInUser!.age.toString();
      bool changedEmail =
          _email.text != Authentication().loggedInUser!.email.toString();
      bool changedName = _name.text != UserAPI().loggedInUser!.name;
      bool changedPhoto = imageFile != null;
      bool changedPassword = newPassword.isNotEmpty;
      bool changedGenrePreferences = newGenrePreferences.isNotEmpty;

      UserAPI().updateUserPreferences(
          age: changedAge ? int.parse(_age.text) : null,
          name: changedName ? _name.text : null,
          email: changedEmail ? _email.text : null,
          imageFile: changedPhoto ? imageFile : null,
          password: changedPassword ? newPassword : null,
          selectedGenres: changedGenrePreferences ? newGenrePreferences : null);

      showPopupMessageWithFunction(
          context, "success", "Your changes have been saved!", false, () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      });
    }
  }

  Future _navigateAndDisplayChange(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InputScreen(text: _name.text)),
    );

    setState(
      () {
        _name.text = result;
      },
    );
  }

  Future _getPasswordChanged(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
    );

    setState(
      () {
        newPassword = result;
      },
    );
  }

  Future _getNewGenrePreferences(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChooseGenresScreen()),
    );

    setState(
      () {
        newGenrePreferences = result;
      },
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

  SizedBox _buildQuarterCircle(double height, Color color) {
    return SizedBox(
      height: height,
      child: QuarterCircle(
        color: color,
        circleAlignment: CircleAlignment.topRight,
      ),
    );
  }
}
