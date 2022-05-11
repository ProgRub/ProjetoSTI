import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  User? loggedInUser;

  Future<void> addUser(User user, XFile imageFile) async {
    var signingUpUser = await collection.add({
      "age": user.age,
      "gender": user.gender,
      "name": user.name,
      "authId": Authentication().loggedInUser!.uid,
      "imageDownloadUrl": await uploadProfilePicture(
          imageFile, Authentication().loggedInUser!.uid),
      "genrePreferences": {},
      "favouriteMovies": {},
      "favouriteTvShows": {}
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

  Future<void> setFavouriteTvShowOrMovie(String type, String id) async {
    var user = collection.doc(loggedInUser!.id);
    List<dynamic> favourites = <String>[];

    await user.get().then((doc) {
      favourites =
          doc.data()![type == "movie" ? "favouriteMovies" : "favouriteTvShow"];
    });

    print(favourites);
    print(type);
    print(id);

    if (!favourites.contains(id)) {
      favourites.add(id);

      user.update({
        (type == "movie" ? "favouriteMovies" : "favouriteTvShows"): favourites
      });
    } else {
      print("ALREADY FAVOURITED");
    }

    loggedInUser!.favouriteMovies = favourites;
  }

  Future<void> setLoggedInUser() async {
    var firstWhere = (await collection.get()).docs.firstWhere(
        (element) => element["authId"] == Authentication().loggedInUser!.uid);
    Map<String, num> map = Map.from(firstWhere["genrePreferences"]);
    loggedInUser = User.fromDocSnapshotAndMap(firstWhere, map);
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
