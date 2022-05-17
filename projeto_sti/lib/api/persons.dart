import 'package:cloud_firestore/cloud_firestore.dart';

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
