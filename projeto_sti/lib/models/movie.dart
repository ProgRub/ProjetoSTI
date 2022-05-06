import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class Movie {
  String id;
  int year;
  double rating;
  List<String> genres;
  String plot, title, poster, length, language, ageRating;
  List<String> cast, directors, writers;

  Movie(
      {required this.id,
      required this.year,
      required this.rating,
      required this.genres,
      required this.plot,
      required this.title,
      required this.poster,
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
    return Image.network(url);
  }
}
