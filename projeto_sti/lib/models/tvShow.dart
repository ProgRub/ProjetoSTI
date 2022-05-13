import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class TvShow {
  String id;
  int seasons;
  double rating;
  List<String> genres;
  String plot,
      years,
      title,
      poster,
      runtime,
      language,
      ageRating,
      wallpaper,
      trailer;
  List<String> cast, directors, writers;

  TvShow(
      {required this.id,
      required this.years,
      required this.seasons,
      required this.rating,
      required this.genres,
      required this.plot,
      required this.title,
      required this.poster,
      required this.wallpaper,
      required this.cast,
      required this.runtime,
      required this.language,
      required this.ageRating,
      required this.directors,
      required this.writers,
      required this.trailer});

  TvShow.fromApi(QueryDocumentSnapshot<Map<String, dynamic>> apiResponse)
      : id = apiResponse.id,
        years = apiResponse["Year"],
        seasons = apiResponse["totalSeasons"],
        rating = apiResponse["imdbRating"],
        genres = apiResponse["Genre"].cast<String>(),
        plot = apiResponse["Plot"],
        title = apiResponse["Title"],
        poster = apiResponse["Poster"],
        wallpaper = apiResponse["Wallpaper"],
        cast = apiResponse["Actors"].cast<String>(),
        runtime = apiResponse["Runtime"],
        language = apiResponse["Language"],
        ageRating = apiResponse["Rated"],
        directors = apiResponse["Director"].cast<String>(),
        writers = apiResponse["Writer"].cast<String>(),
        trailer = apiResponse["Trailer"];

  Future<Image> getPoster() async {
    Reference ref =
        FirebaseStorage.instance.ref().child("tvShowPosters/" + poster);
    String url = (await ref.getDownloadURL()).toString();
    return Image.network(url, width: 150, height: 220, fit: BoxFit.fill);
  }

  Future<Image> getWallpaper(double height,
      [double width = double.infinity]) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("tvShowWallpapers/Wallpaper " + wallpaper);
    String url = (await ref.getDownloadURL()).toString();
    return Image.network(url, width: width, height: height, fit: BoxFit.cover);
  }
}
