import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Genre {
  static List<Genre> genres = [];
  String name, image;
  Color color;

  Genre({required this.name, required this.color, required this.image});

  Genre.fromApi(QueryDocumentSnapshot<Map<String, dynamic>> apiResponse)
      : name = apiResponse["name"],
        image = apiResponse["Image"],
        color = Color(apiResponse["color"]);

  Future<Image> getImage(
      [double height = 50, double width = double.infinity]) async {
    Reference ref =
        FirebaseStorage.instance.ref().child("genreImages/" + image);
    String url = (await ref.getDownloadURL()).toString();
    return Image.network(url, width: width, height: height, fit: BoxFit.cover);
  }
}
