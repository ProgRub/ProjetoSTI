import 'package:flutter/material.dart';
import 'package:projeto_sti/api/genres.dart';
import 'package:device_preview/device_preview.dart';
import 'package:projeto_sti/screens/mainScreen.dart';
import 'package:projeto_sti/screens/movieInfoScreen.dart';
import 'package:projeto_sti/styles/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splashscreen/splashscreen.dart';

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
    GenresAPI.getAllGenres();

    var appName = Text.rich(
      TextSpan(
        text: "POP",
        style: GoogleFonts.openSans(
          fontSize: 55,
          fontWeight: FontWeight.w900,
          color: const Color.fromRGBO(47, 253, 246, 1),
        ),
        children: <TextSpan>[
          TextSpan(
            text: "CORN",
            style: GoogleFonts.openSans(
              fontSize: 55,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );

    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(
        seconds: 5,
        navigateAfterSeconds: const MainScreen(),
        backgroundColor: Styles.colors.background,
        loaderColor: Styles.colors.lightBlue,
        title: appName,
      ),
    );
  }
}

// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:bubble_chart/bubble_chart.dart';
// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<BubbleNode> childNode = [];

//   @override
//   void initState() {
//     super.initState();
//     _addNewNode();
//     // Timer.periodic(Duration(milliseconds: 500), (_) {
//     //   _addNewNode();
//     // });
//   }

//   _addNewNode() {
//     setState(() {
//       Random random = Random();
//       BubbleNode node = BubbleNode.leaf(
//         value: max(1, random.nextInt(10)),
//         options: BubbleOptions(
//           color: () {
//             Random random = Random();
//             return Colors.primaries[random.nextInt(Colors.primaries.length)];
//           }(),
//         ),
//       );
//       node.options?.onTap = () {
//         setState(() {
//           node.value += 1;
//           // childNode.remove(node);
//         });
//       };
//       childNode.add(node);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: BubbleChartLayout(
//           padding: 10,
//           children: [
//             BubbleNode.node(
//               padding: 15,
//               children: childNode,
//               options: BubbleOptions(
//                   color: Colors.black,
//                   border: Border.all(color: Colors.white, width: 15)),
//             ),
//             BubbleNode.node(
//               padding: 15,
//               children: [
//                 BubbleNode.leaf(
//                   value: 5,
//                   options: BubbleOptions(
//                     color: () {
//                       Random random = Random();
//                       return Colors
//                           .primaries[random.nextInt(Colors.primaries.length)];
//                     }(),
//                   ),
//                 )
//               ],
//               options: BubbleOptions(
//                   color: Colors.black,
//                   border: Border.all(color: Colors.white, width: 15)),
//             ),
//           ],
//           duration: Duration(milliseconds: 500),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Text("+"),
//         onPressed: () {
//           _addNewNode();
//         },
//       ),
//     );
//   }
// }
