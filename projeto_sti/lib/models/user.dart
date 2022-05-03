import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id, name, gender;
  int age;
  Map<String, double> genderPreferences;

  User(
      {required this.id,
      required this.name,
      required this.gender,
      required this.age,
      required this.genderPreferences});

  User.fromApi(QueryDocumentSnapshot<Map<String, dynamic>> apiResponse)
      : id = apiResponse.id,
        name = apiResponse["name"],
        gender = apiResponse["gender"],
        age = apiResponse["age"],
        genderPreferences = apiResponse["genrePreferences"];
}
