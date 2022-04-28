import 'package:cloud_firestore/cloud_firestore.dart';

class UserAPI {
  UserAPI._privateConstructor();

  static final UserAPI _instance = UserAPI._privateConstructor();

  factory UserAPI() {
    return _instance;
  }
}
