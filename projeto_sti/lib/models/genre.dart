import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Genre {
  static List<Genre> genres = [];
  String name;
  Color color;

  Genre({required this.name, required this.color});
}
