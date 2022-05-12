import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id, name, gender, imageDownloadUrl, authId;
  int age;
  Map<String, num> genrePreferences;
  List<dynamic> favouriteMovies,
      favouriteTvShows,
      watchedMovies,
      watchedTvShows;

  UserModel(
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

  UserModel.fromApi(QueryDocumentSnapshot<Map<String, dynamic>> apiResponse)
      : id = apiResponse.id,
        name = apiResponse["name"],
        gender = apiResponse["gender"],
        age = apiResponse["age"],
        authId = apiResponse["authId"],
        genrePreferences = apiResponse["genrePreferences"],
        imageDownloadUrl = apiResponse["imageDownloadUrl"],
        favouriteMovies = apiResponse["favouriteMovies"],
        favouriteTvShows = apiResponse["favouriteTvShows"],
        watchedMovies = apiResponse["watchedMovies"],
        watchedTvShows = apiResponse["watchedTvShows"];

  UserModel.fromDocSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot)
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

  UserModel.fromDocSnapshotAndMap(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot,
      Map<String, num> genrePrefs)
      : id = documentSnapshot.id,
        name = documentSnapshot["name"],
        gender = documentSnapshot["gender"],
        age = documentSnapshot["age"],
        authId = documentSnapshot["authId"],
        imageDownloadUrl = documentSnapshot["imageDownloadUrl"],
        favouriteMovies = documentSnapshot["favouriteMovies"].values,
        favouriteTvShows = documentSnapshot["favouriteTvShows"].values,
        watchedMovies = documentSnapshot["watchedMovies"].values,
        watchedTvShows = documentSnapshot["watchedTvShows"].values,
        genrePreferences = genrePrefs;
}
