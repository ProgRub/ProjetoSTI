import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class Person {
  String id;
  String name, summary, type, photo;
  num awardWins, awardNominations;

  Person(
      {required this.id,
      required this.name,
      required this.summary,
      required this.photo,
      required this.type,
      required this.awardWins,
      required this.awardNominations});

  Person.fromApi(DocumentSnapshot<Map<String, dynamic>> apiResponse)
      : id = apiResponse.id,
        name = apiResponse["name"],
        summary = apiResponse["summary"],
        type = apiResponse["type"],
        photo = apiResponse["photo"],
        awardWins = apiResponse["awardWins"],
        awardNominations = apiResponse["awardNoms"];

  Future<Image> getPhoto() async {
    Reference ref =
        FirebaseStorage.instance.ref().child("personPhotos/" + photo);
    String url = (await ref.getDownloadURL()).toString();
    return Image.network(url);
  }
}
