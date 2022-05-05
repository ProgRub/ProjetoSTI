import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> addUser(User user) async {
    var signingUpUser = await collection.add({
      "age": user.age,
      "gender": user.gender,
      "name": user.name,
      "authId": Authentication().loggedInUser!.uid,
      "genrePreferences": {}
    });
    setLoggedInUser();
  }

  Future<void> setUserPreferences(List<String> selectedGenres) async {
    var genres = await GenresAPI().getAllGenres();
    Map<String, double> genrePreferences = {};
    for (var genre in genres) {
      genrePreferences
          .addAll({genre.name: (selectedGenres.contains(genre.name)) ? 1 : 0});
    }
    var user = collection.doc(loggedInUser!.id);
    user.update({"genrePreferences": genrePreferences});
    loggedInUser!.genrePreferences = genrePreferences;
  }

  Future<void> setLoggedInUser() async {
    var firstWhere = (await collection.get()).docs.firstWhere(
        (element) => element["authId"] == Authentication().loggedInUser!.uid);
    Map<String, double> map = Map.from(firstWhere["genrePreferences"]);
    loggedInUser = User.fromDocSnapshotAndMap(firstWhere, map);
  }

  Future<void> uploadProfilePicture() async {}
}
