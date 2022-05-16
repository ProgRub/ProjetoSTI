import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_sti/api/users.dart';
import 'package:projeto_sti/models/movie.dart';
import 'package:projeto_sti/models/tvShow.dart';

import 'package:http/http.dart' as http;

import '../models/person.dart';

class PersonsAPI {
  PersonsAPI._privateConstructor();

  static final PersonsAPI _instance = PersonsAPI._privateConstructor();

  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection('persons');

  factory PersonsAPI() {
    return _instance;
  }
  Future<Person> getPersonByID(String id) async =>
      Person.fromApi(await collection.doc(id).get());
}
