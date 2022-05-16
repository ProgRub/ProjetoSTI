import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class Movie {
  String id;
  int year;
  double rating;
  List<String> genres;
  String plot, title, poster, length, language, ageRating, wallpaper, trailer;
  List<String> cast, directors, writers, videos;

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
      required this.writers,
      required this.videos,
      required this.trailer});

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
        writers = apiResponse["Writer"].cast<String>(),
        videos = apiResponse["Videos"].cast<String>(),
        trailer = apiResponse["Trailer"];

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

  Future<List<String>> getPhotos() async {
    List<String> listImages = [];
    Reference ref = FirebaseStorage.instance.ref().child("moviePhotos/");

    await ref.listAll().then((result) async {
      for (var photo in result.items.where((element) =>
          (title.contains(":") &&
              title.length >= 5 &&
              (element.fullPath.contains(title.substring(0, 4)))) ||
          element.fullPath.contains(title))) {
        String url = (await photo.getDownloadURL()).toString();
        listImages.add(url);
      }
    });

    return listImages;
  }
}
