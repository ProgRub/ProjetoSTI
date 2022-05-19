import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class Person {
  String id;
  String name, summary, type, photo, born, died;
  num awardWins, awardNominations;

  Person(
      {required this.id,
      required this.name,
      required this.summary,
      required this.photo,
      required this.type,
      required this.awardWins,
      required this.born,
      required this.died,
      required this.awardNominations});

  Person.fromApi(DocumentSnapshot<Map<String, dynamic>> apiResponse)
      : id = apiResponse.id,
        name = apiResponse["name"],
        summary = apiResponse["summary"],
        type = apiResponse["type"],
        photo = apiResponse["photo"],
        born = apiResponse["born"],
        died = apiResponse["died"],
        awardWins = apiResponse["awardWins"],
        awardNominations = apiResponse["awardNoms"];

  Future<Image> getPhoto() async {
    return Image.network(photo);
  }
}
