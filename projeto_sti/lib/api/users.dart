import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_sti/api/authentication.dart';
import 'package:projeto_sti/api/comments.dart';
import 'package:projeto_sti/api/genres.dart';
import 'package:projeto_sti/api/movies.dart';
import 'package:projeto_sti/api/tvShows.dart';

import '../models/movie.dart';
import '../models/tvShow.dart';
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
      "watchedTvShows": [],
      "dailySuggestions": {}
    });
    setLoggedInUser();
  }

  Future<void> deleteUser() async {
    await CommentAPI().deleteUserComments(loggedInUser!.id);
    await collection.doc(loggedInUser!.id).delete();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("userPictures/" + Authentication().loggedInUser!.uid);
    await ref.delete();

    loggedInUser = null;
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
    if (loggedInUser == null) return [];

    loggedInUser!.genrePreferences.forEach((key, value) {
      if (value == 1) genres.add(key);
    });

    return genres;
  }

  Future<void> updateUserPreferences(
      {int? age,
      String? name,
      XFile? imageFile,
      String? email,
      String? password,
      List<String>? selectedGenres}) async {
    var user = collection.doc(loggedInUser!.id);
    Map<String, Object> changes = {};

    if (age != null) {
      loggedInUser!.age = age;
      changes["age"] = age;
    }

    if (name != null) {
      loggedInUser!.name = name;
      changes["name"] = name;
    }

    if (imageFile != null) {
      var image = await uploadProfilePicture(
          imageFile, Authentication().loggedInUser!.uid);
      loggedInUser!.imageDownloadUrl = image;
      changes["imageDownloadUrl"] = image;
    }

    await user.update(changes);

    if (selectedGenres != null) setUserPreferences(selectedGenres);

    if (email != null) {
      await Authentication().auth.currentUser!.updateEmail(email);
    }

    if (password != null) {
      await Authentication().auth.currentUser!.updatePassword(password);
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
      MoviesAPI().changeFavouriteCount(id, 1);
    } else {
      loggedInUser!.favouriteTvShows = favourites;
      TVShowsAPI().changeFavouriteCount(id, 1);
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
      MoviesAPI().changeFavouriteCount(id, -1);
    } else {
      loggedInUser!.favouriteTvShows = favourites;
      TVShowsAPI().changeFavouriteCount(id, -1);
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
      MoviesAPI().changeWatchedCount(id, 1);
    } else {
      loggedInUser!.watchedTvShows = watched;
      TVShowsAPI().changeWatchedCount(id, 1);
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
      MoviesAPI().changeWatchedCount(id, -1);
    } else {
      loggedInUser!.watchedTvShows = watched;
      TVShowsAPI().changeWatchedCount(id, -1);
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

  Future<List<String>> getUserById(String userId) async {
    var users = await collection.get();
    List<String> returnUser = [];
    for (var user in users.docs) {
      if (user["authId"] == userId) {
        returnUser.add(user["name"]);
        returnUser.add(user["imageDownloadUrl"]);
      }
    }
    return returnUser;
  }

  Future<dynamic> getDailySuggestion(Future<List<Movie>> moviesFuture,
      Future<List<TvShow>> tvShowsFuture) async {
    var movies = await moviesFuture;
    var tvShows = await tvShowsFuture;
    var user = collection.doc(loggedInUser!.id);
    List<dynamic> dailySuggestions = <String>[];
    await user.get().then((doc) {
      dailySuggestions = doc["dailySuggestions"];
    });
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    List<String> alreadySuggestedPrograms = [];
    for (var item in dailySuggestions) {
      try {
        if (item["date"] == date.toString().split(" ")[0]) {
          print(item["programId"]);
          dynamic program =
              movies.where((element) => element.id == item["programId"]);
          if (program.length != 0) return program.first;
          return tvShows
              .firstWhere((element) => element.id == item["programId"]);
        } else {
          alreadySuggestedPrograms.add(item["programId"]);
        }
      } catch (e) {}
    }
    List<dynamic> programs = [...movies, ...tvShows];
    Set<String> preferredGenres = loggedInUser!.genrePreferences.keys
        .where((element) => loggedInUser!.genrePreferences[element]! > 0.75)
        .toSet();
    Map<dynamic, num> preferredPrograms = {};
    for (var program in programs) {
      Set genresProgram = (program.genres).toSet();
      preferredPrograms.addEntries({
        program.id: genresProgram.intersection(preferredGenres).length /
            genresProgram.length
      }.entries);
    }
    var sortedPrograms = preferredPrograms.entries.toList()
      ..sort((e1, e2) {
        return e2.value.compareTo(e1.value);
      });
    for (var program in sortedPrograms) {
      if (!alreadySuggestedPrograms.contains(program.key)) {
        collection.doc(loggedInUser!.id).update({
          "dailySuggestions": FieldValue.arrayUnion([
            {"date": date.toString().split(" ")[0], "programId": program.key}
          ])
        });
        return programs.firstWhere((element) => element.id == program.key);
      }
    }
    return null;
  }
}
