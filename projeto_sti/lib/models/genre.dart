import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Genre {
  static List<Genre> genres = [];
  String name;
  Color color;

  Genre({required this.name, required this.color});

  Genre.fromApi(QueryDocumentSnapshot<Map<String, dynamic>> apiResponse)
      : name = apiResponse["name"],
        color = Color(apiResponse["color"]);
}
