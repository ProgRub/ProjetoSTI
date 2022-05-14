import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_sti/api/authentication.dart';
import 'package:projeto_sti/api/genres.dart';

import '../models/user.dart';

class UserAPI {
  UserAPI._privateConstructor();

  static final UserAPI _instance = UserAPI._privateConstructor();
  factory UserAPI() {
    return _instance;
  }
  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection('users');

  UserModel? loggedInUser;

  Future<void> addUser(UserModel user, XFile imageFile) async {
    var signingUpUser = await collection.add({
      "age": user.age,
      "gender": user.gender,
      "name": user.name,
      "authId": Authentication().loggedInUser!.uid,
      "imageDownloadUrl": await uploadProfilePicture(
          imageFile, Authentication().loggedInUser!.uid),
      "genrePreferences": {},
      "favouriteMovies": [],
      "favouriteTvShows": [],
      "watchedMovies": [],
      "watchedTvShows": []
    });
    setLoggedInUser();
  }

  Future<void> setUserPreferences(List<String> selectedGenres) async {
    var genres = await GenresAPI().getAllGenres();
    Map<String, num> genrePreferences = {};
    for (var genre in genres) {
      genrePreferences
          .addAll({genre.name: (selectedGenres.contains(genre.name)) ? 1 : 0});
    }
    var user = collection.doc(loggedInUser!.id);
    user.update({"genrePreferences": genrePreferences});
    loggedInUser!.genrePreferences = genrePreferences;
  }

  List<String> getGenrePreferences() {
    List<String> genres = <String>[];
    loggedInUser!.genrePreferences.forEach((key, value) {
      if (value == 1) genres.add(key);
    });

    return genres;
  }

  Future<void> updateUserPreferences(
      {int? age, String? name, XFile? imageFile, String? email}) async {
    var user = collection.doc(loggedInUser!.id);
    if (age != null) {
      loggedInUser!.age = age;
      user.update({"age": age});
    }

    if (name != null) {
      loggedInUser!.name = name;
      user.update({"name": name});
    }

    if (imageFile != null) {
      var image = await uploadProfilePicture(
          imageFile, Authentication().loggedInUser!.uid);
      loggedInUser!.imageDownloadUrl = image;
      user.update({"imageDownloadUrl": image});
    }

    if (email != null) {
      Authentication().auth.currentUser!.updateEmail(email);
    }
  }

  Future<void> setFavouriteTvShowOrMovie(String type, String id) async {
    var user = collection.doc(loggedInUser!.id);
    List<dynamic> favourites = <String>[];

    await user.get().then((doc) {
      favourites =
          doc[type == "movie" ? "favouriteMovies" : "favouriteTvShows"];
    });

    if (!favourites.contains(id)) {
      favourites.add(id);

      user.update({
        (type == "movie" ? "favouriteMovies" : "favouriteTvShows"): favourites
      });
    }

    if (type == "movie") {
      loggedInUser!.favouriteMovies = favourites;
    } else {
      loggedInUser!.favouriteTvShows = favourites;
    }
  }

  Future<void> removeFavouriteTvShowOrMovie(String type, String id) async {
    var user = collection.doc(loggedInUser!.id);
    List<dynamic> favourites = <String>[];

    await user.get().then((doc) {
      favourites =
          doc[type == "movie" ? "favouriteMovies" : "favouriteTvShows"];
    });

    if (favourites.contains(id)) {
      favourites.remove(id);

      user.update({
        (type == "movie" ? "favouriteMovies" : "favouriteTvShows"): favourites
      });
    }
    if (type == "movie") {
      loggedInUser!.favouriteMovies = favourites;
    } else {
      loggedInUser!.favouriteTvShows = favourites;
    }
  }

  Future<void> setWatchedTvShowOrMovie(String type, String id) async {
    var user = collection.doc(loggedInUser!.id);
    List<dynamic> watched = <String>[];

    await user.get().then((doc) {
      watched = doc[type == "movie" ? "watchedMovies" : "watchedTvShows"];
    });

    if (!watched.contains(id)) {
      watched.add(id);

      user.update(
          {(type == "movie" ? "watchedMovies" : "watchedTvShows"): watched});
    }

    if (type == "movie") {
      loggedInUser!.watchedMovies = watched;
    } else {
      loggedInUser!.watchedTvShows = watched;
    }
  }

  Future<void> removeWatchedTvShowOrMovie(String type, String id) async {
    var user = collection.doc(loggedInUser!.id);
    List<dynamic> watched = <String>[];

    await user.get().then((doc) {
      watched = doc[type == "movie" ? "watchedMovies" : "watchedTvShows"];
    });

    if (watched.contains(id)) {
      watched.remove(id);

      user.update(
          {(type == "movie" ? "watchedMovies" : "watchedTvShows"): watched});
    }
    if (type == "movie") {
      loggedInUser!.watchedMovies = watched;
    } else {
      loggedInUser!.watchedTvShows = watched;
    }
  }

  Future<void> setLoggedInUser() async {
    var docs = (await collection.get()); //.firstWhere(
    //(element) => element["authId"] == Authentication().loggedInUser!.uid)
    QueryDocumentSnapshot<Map<String, dynamic>>? user;
    for (var element in docs.docs) {
      if (element["authId"] == Authentication().loggedInUser!.uid) {
        user = element;
        break;
      }
    }
    Map<String, num> map = Map.from(user!["genrePreferences"]);
    loggedInUser = UserModel(
        id: user.id,
        name: user["name"],
        gender: user["gender"],
        imageDownloadUrl: user["imageDownloadUrl"],
        authId: user["authId"],
        age: user["age"],
        genrePreferences: map,
        favouriteMovies: user["favouriteMovies"],
        favouriteTvShows: user["favouriteTvShows"],
        watchedMovies: user["watchedMovies"],
        watchedTvShows: user["watchedTvShows"]);
  }

  Future<String> uploadProfilePicture(XFile imageFile, String filename) async {
    print(imageFile);
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("userPictures/" + Authentication().loggedInUser!.uid);
    var image = await ref.putData(await imageFile.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'));
    return image.ref.getDownloadURL();
  }
}
