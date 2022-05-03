import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:projeto_sti/api/authentication.dart';
import 'package:projeto_sti/api/configurations.dart';
import 'package:projeto_sti/api/genres.dart';
import 'package:device_preview/device_preview.dart';
import 'package:projeto_sti/api/movies.dart';
import 'package:projeto_sti/screens/byGenreScreen.dart';
import 'package:projeto_sti/screens/chooseGenresScreen.dart';
import 'package:projeto_sti/screens/editProfileScreen.dart';
import 'package:projeto_sti/screens/favouritesScreen.dart';
import 'package:projeto_sti/screens/genresScreen.dart';
import 'package:projeto_sti/screens/loginScreen.dart';
import 'package:projeto_sti/screens/mainScreen.dart';
import 'package:projeto_sti/screens/splashScreen.dart';
import 'package:projeto_sti/screens/topImdbScreen.dart';
import 'package:projeto_sti/styles/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  MoviesAPI().getAllMovies();
  runApp(DevicePreview(
    enabled: false, //COLOCAR A TRUE PARA TESTAR RESPONSIVIDADE
    builder: (context) => MaterialApp(
      home: const MyApp(),
    ), // Wrap your app
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'POPCORN',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
