import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Genre {
  static List<Genre> genres = [];
  late String name;
  late Color color;

  Genre({required this.name, required this.color}) {
    genres.add(this);
  }

  Genre.fromApi(QueryDocumentSnapshot<Map<String, dynamic>> apiResponse) {
    genres.add(
        Genre(name: apiResponse["name"], color: Color(apiResponse["color"])));
  }
}
