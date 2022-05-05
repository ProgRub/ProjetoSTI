import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id, name, gender;
  int age;
  Map<String, double> genrePreferences;

  User(
      {required this.id,
      required this.name,
      required this.gender,
      required this.age,
      required this.genrePreferences});

  User.fromApi(QueryDocumentSnapshot<Map<String, dynamic>> apiResponse)
      : id = apiResponse.id,
        name = apiResponse["name"],
        gender = apiResponse["gender"],
        age = apiResponse["age"],
        genrePreferences = apiResponse["genrePreferences"];

  User.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> documentSnapshot)
      : id = documentSnapshot.id,
        name = documentSnapshot["name"],
        gender = documentSnapshot["gender"],
        age = documentSnapshot["age"],
        genrePreferences = documentSnapshot["genrePreferences"];

  User.fromDocSnapshotAndMap(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot,
      Map<String, double> genrePrefs)
      : id = documentSnapshot.id,
        name = documentSnapshot["name"],
        gender = documentSnapshot["gender"],
        age = documentSnapshot["age"],
        genrePreferences = genrePrefs;
}
