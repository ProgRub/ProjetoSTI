import 'dart:convert';
import 'package:flutter/services.dart';

abstract class GenresAPI {
  static List<String> genres = [];
  static Future<void> getAllGenres() async {
    if (genres.isNotEmpty) return;
    String response = await rootBundle
        .loadString('packages/projeto_sti/assets/db/genres.json');
    List<dynamic> data = json.decode(response);
    if (genres.isNotEmpty) return;
    for (var element in data) {
      genres.add(element['name']);
    }
  }
}
