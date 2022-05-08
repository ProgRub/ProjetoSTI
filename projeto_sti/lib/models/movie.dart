import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class Movie {
  String id;
  int year;
  double rating;
  List<String> genres;
  String plot, title, poster, length, language, ageRating, wallpaper;
  List<String> cast, directors, writers;

  Movie(
      {required this.id,
      required this.year,
      required this.rating,
      required this.genres,
      required this.plot,
      required this.title,
      required this.poster,
      required this.wallpaper,
      required this.cast,
      required this.length,
      required this.language,
      required this.ageRating,
      required this.directors,
      required this.writers});

  Movie.fromApi(QueryDocumentSnapshot<Map<String, dynamic>> apiResponse)
      : id = apiResponse.id,
        cast = apiResponse["Actors"].cast<String>(),
        directors = apiResponse["Director"].cast<String>(),
        genres = apiResponse["Genre"].cast<String>(),
        rating = apiResponse["imdbRating"],
        year = apiResponse["Year"],
        plot = apiResponse["Plot"],
        wallpaper = apiResponse["Wallpaper"],
        title = apiResponse["Title"],
        language = apiResponse["Language"],
        length = apiResponse["Runtime"],
        ageRating = apiResponse["Rated"],
        poster = apiResponse["Poster"],
        writers = apiResponse["Writer"].cast<String>();

  Future<Image> getPoster() async {
    Reference ref =
        FirebaseStorage.instance.ref().child("moviePosters/" + poster);
    String url = (await ref.getDownloadURL()).toString();
    return Image.network(url, width: 150, height: 220, fit: BoxFit.fill);
  }

  Future<Image> getWallpaper(double height,
      [double width = double.infinity]) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("movieWallpapers/Wallpaper " + wallpaper);
    String url = (await ref.getDownloadURL()).toString();
    return Image.network(url, width: width, height: height, fit: BoxFit.cover);
  }
}
