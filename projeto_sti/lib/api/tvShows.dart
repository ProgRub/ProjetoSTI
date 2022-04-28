import 'package:cloud_firestore/cloud_firestore.dart';

class TVShowsAPI {
  TVShowsAPI._privateConstructor();

  static final TVShowsAPI _instance = TVShowsAPI._privateConstructor();

  factory TVShowsAPI() {
    return _instance;
  }
}
