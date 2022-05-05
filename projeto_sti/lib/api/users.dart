import 'package:cloud_firestore/cloud_firestore.dart';
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

  late DocumentReference<Map<String, dynamic>> signingUpUser;
  Future<void> addUser(User user) async {
    signingUpUser = await collection.add({
      "age": user.age,
      "gender": user.gender,
      "name": user.name,
      "genrePreferences": {}
    });
  }

  Future<void> setUserPreferences(List<String> selectedGenres) async {
    var genres = await GenresAPI().getAllGenres();
    Map<String, double> genrePreferences = {};
    for (var genre in genres) {
      genrePreferences
          .addAll({genre.name: (selectedGenres.contains(genre.name)) ? 1 : 0});
    }
    signingUpUser.update({"genrePreferences": genrePreferences});
  }
}
