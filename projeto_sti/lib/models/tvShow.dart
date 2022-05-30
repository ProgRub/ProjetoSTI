import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class TvShow {
  String id;
  int seasons, timesWatched, timesFavourited;
  double rating;
  List<String> genres, videos;
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
      required this.videos,
      required this.trailer,
      required this.timesWatched,
      required this.timesFavourited});

  TvShow.fromApi(DocumentSnapshot<Map<String, dynamic>> apiResponse)
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
        videos = apiResponse["Videos"].cast<String>(),
        directors = apiResponse["Director"].cast<String>(),
        writers = apiResponse["Writer"].cast<String>(),
        trailer = apiResponse["Trailer"],
        timesWatched = apiResponse["timesWatched"],
        timesFavourited = apiResponse["timesFavourited"];

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

  Future<List<String>> getPhotos() async {
    List<String> listImages = [];
    Reference ref = FirebaseStorage.instance.ref().child("tvShowPhotos/");

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
