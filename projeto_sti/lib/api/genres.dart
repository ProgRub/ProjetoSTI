import 'dart:convert';
import 'package:flutter/services.dart';

abstract class GenresAPI {
  static List<String> Genres = [];
  static Future<void> getAllGenres() async {
    if (Genres.isNotEmpty) return;
    String response = await rootBundle
        .loadString('packages/projeto_sti/assets/db/genres.json');
    List<dynamic> data = json.decode(response);
    if (Genres.isNotEmpty) return;
    data.forEach((element) {
      Genres.add(element['name']);
    });
  }
}
