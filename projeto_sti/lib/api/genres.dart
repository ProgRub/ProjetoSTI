import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/genre.dart';

class GenresAPI {
  GenresAPI._privateConstructor();

  static final GenresAPI _instance = GenresAPI._privateConstructor();
  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection('genres');

  factory GenresAPI() {
    return _instance;
  }
  FirebaseFirestore firebase = FirebaseFirestore.instance;

  Future<List<Genre>> getAllGenres() async {
    await getNewGenresFromMoviesAndTvShows();
    List<Genre> genres = [];
    var genresApi = await collection.get();
    for (var genre in genresApi.docs) {
      genres.add(Genre.fromApi(genre));
      // collection.doc(genre.id).update({"Image": genres.last.name + ".jpg"});
      // print(genres.last.name);
    }
    return genres;
  }

  Future<void> getNewGenresFromMoviesAndTvShows() async {
    var genres = [];
    var movies = await firebase.collection('movies').get();
    for (var element in movies.docs) {
      try {
        genres.addAll(element['Genre'].cast<String>());
      } catch (e) {
        genres.add(element['Genre']);
      }
    }
    for (var genre in genres) {
      addGenreIfNotInDB(genre);
    }
    var tvShows = await firebase.collection('tvShows').get();
    for (var element in tvShows.docs) {
      try {
        genres.addAll(element['Genre'].cast<String>());
      } catch (e) {
        genres.add(element['Genre']);
      }
    }
    for (var genre in genres) {
      addGenreIfNotInDB(genre);
    }
  }

  Future<void> addGenreIfNotInDB(String name) async {
    var genres = await collection.get();
    var genreNamesInDB = [];
    for (var genre in genres.docs) {
      genreNamesInDB.add(genre['name']);
    }
    if (genreNamesInDB.contains(name)) return;
    addGenre(name);
  }

  Future<void> addGenre(String name, {Color color = Colors.white}) async {
    collection.add({'name': name, 'color': color.value});
  }

  Future<List<Genre>> getGenresByName(List<String> names) async {
    var genres = await collection.get();
    List<Genre> genresList = [];
    for (var genre in names) {
      genresList.add(Genre.fromApi(
          genres.docs.firstWhere((element) => element["name"] == genre)));
    }
    return genresList;
  }
}
