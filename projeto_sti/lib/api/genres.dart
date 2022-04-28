import 'package:cloud_firestore/cloud_firestore.dart';

class GenresAPI {
  GenresAPI._privateConstructor();

  static final GenresAPI _instance = GenresAPI._privateConstructor();

  factory GenresAPI() {
    return _instance;
  }

  List<String> genres = [];
  Future<void> getAllGenres() async {}
}
