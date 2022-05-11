import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id, name, gender, imageDownloadUrl, authId;
  int age;
  Map<String, num> genrePreferences;
  var favouriteMovies, favouriteTvShows, watchedMovies, watchedTvShows;

  User(
      {required this.id,
      required this.name,
      required this.gender,
      required this.imageDownloadUrl,
      required this.authId,
      required this.age,
      required this.genrePreferences,
      required this.favouriteMovies,
      required this.favouriteTvShows,
      required this.watchedMovies,
      required this.watchedTvShows});

  User.fromApi(QueryDocumentSnapshot<Map<String, dynamic>> apiResponse)
      : id = apiResponse.id,
        name = apiResponse["name"],
        gender = apiResponse["gender"],
        age = apiResponse["age"],
        authId = apiResponse["authId"],
        genrePreferences = apiResponse["genrePreferences"],
        favouriteMovies = apiResponse["favouriteMovies"],
        favouriteTvShows = apiResponse["favouriteTvShows"],
        imageDownloadUrl = apiResponse["imageDownloadUrl"],
        watchedMovies = apiResponse["watchedMovies"],
        watchedTvShows = apiResponse["watchedTvShows"];

  User.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> documentSnapshot)
      : id = documentSnapshot.id,
        name = documentSnapshot["name"],
        gender = documentSnapshot["gender"],
        age = documentSnapshot["age"],
        authId = documentSnapshot["authId"],
        imageDownloadUrl = documentSnapshot["imageDownloadUrl"],
        favouriteMovies = documentSnapshot["favouriteMovies"],
        favouriteTvShows = documentSnapshot["favouriteTvShows"],
        genrePreferences = documentSnapshot["genrePreferences"],
        watchedMovies = documentSnapshot["watchedMovies"],
        watchedTvShows = documentSnapshot["watchedTvShows"];

  User.fromDocSnapshotAndMap(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot,
      Map<String, num> genrePrefs)
      : id = documentSnapshot.id,
        name = documentSnapshot["name"],
        gender = documentSnapshot["gender"],
        age = documentSnapshot["age"],
        authId = documentSnapshot["authId"],
        imageDownloadUrl = documentSnapshot["imageDownloadUrl"],
        favouriteMovies = documentSnapshot["favouriteMovies"],
        favouriteTvShows = documentSnapshot["favouriteTvShows"],
        watchedMovies = documentSnapshot["watchedMovies"],
        watchedTvShows = documentSnapshot["watchedTvShows"],
        genrePreferences = genrePrefs;
}
