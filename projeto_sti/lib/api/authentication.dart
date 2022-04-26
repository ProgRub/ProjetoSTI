// import 'dart:convert';

// import 'package:firebase_dart/firebase_dart.dart';
// import 'package:shelf_router/shelf_router.dart';
// import 'package:shelf/shelf.dart';

// import 'configurations.dart';

// class Authentication {
//   Future<FirebaseApp> initApp() async {
//     late FirebaseApp app;

//     try {
//       app = Firebase.app();
//     } catch (e) {
//       app = await Firebase.initializeApp(
//           options: FirebaseOptions.fromMap(Configurations.firebaseConfig));
//     }

//     return app;
//   }

//   Handler get handler {
//     var router = Router();
//     router.post('/register', (Request request) async {
//       var payloadData = await request.readAsString();
//       if (payloadData.isEmpty) {
//         return Response.notFound(
//             jsonEncode({'success': false, 'error': 'No data found'}),
//             headers: {'Content-Type': 'application/json'});
//       }
//       final payload = json.decode(payloadData);
//       String? username = payload['username'];
//       String? password = payload['password'];
//       if (username == null || password == null) {
//         return Response.notFound(
//             json.encode({'error': 'Missing username or password'}),
//             headers: {'content-type': 'application/json'});
//       } else if (username.contains(' ')) {
//         return Response.forbidden(
//             json.encode({'error': 'Username cannot contain spaces'}),
//             headers: {'content-type': 'application/json'});
//       }
//       var app = await initApp();
//       var auth = FirebaseAuth.instanceFor(app: app);
//       Future<List> registerUser({
//         String? username,
//         String? password,
//         FirebaseAuth? auth,
//       }) async {
//         try {
//           var userCredential = await auth!.createUserWithEmailAndPassword(
//             email: '$username@company.com'.toLowerCase(),
//             password: password!,
//           );

//           return [
//             1,
//             json.encode({
//               'username': username,
//               'uid': userCredential.user!.uid,
//               'message': 'User created'
//             })
//           ];
//         } on FirebaseAuthException catch (e) {
//           print(e.code);
//           switch (e.code) {
//             case 'weak-password':
//               return [
//                 0,
//                 json.encode({'error': e.message})
//               ];

//             case 'internal-error':
//               return [
//                 0,
//                 json.encode({'error': e.message})
//               ];

//             default:
//               return [
//                 0,
//                 json.encode({'error': e.message})
//               ];
//           }
//         }
//       }
//     });

//     return router;
//   }
// }

//1
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

//2
final FirebaseAuth _auth = FirebaseAuth.instance;

class Authentication {
  Authentication._privateConstructor();

  static final Authentication _instance = Authentication._privateConstructor();

  factory Authentication() {
    return _instance;
  }

  void signOut() async {
    // bool someoneSignedIn = false;
    final User? user = await _auth.currentUser;
    if (user == null) {
      return;
    }
    await _auth.signOut();
    // final String uid = user.uid;
  }

  void registerUser(String email, String password) async {
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      if (user != null) {
        //already exists
      } else {
        //new user created
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  void login(String email, String password) async {
    //Firebase já trata da verificação de email
    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      if (user != null) {
        //sucesso
      } else {
        //erro
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }
}
