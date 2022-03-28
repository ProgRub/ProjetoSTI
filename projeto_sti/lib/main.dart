import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_testing/screens/loginScreen.dart';

void main() {
  runApp(DevicePreview(
    enabled: false, //COLOCAR A TRUE PARA TESTAR RESPONSIVIDADE
    builder: (context) => const MyApp(), // Wrap your app
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
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
