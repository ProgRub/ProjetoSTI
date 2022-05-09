import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_sti/models/movie.dart';

class MoviesAPI {
  MoviesAPI._privateConstructor();

  static final MoviesAPI _instance = MoviesAPI._privateConstructor();

  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection('movies');

  factory MoviesAPI() {
    return _instance;
  }
  Future<List<Movie>> getAllMovies() async {
    var movies = await collection.get();
    List<Movie> returnMovies = [];
    for (var movie in movies.docs) {
      returnMovies.add(Movie.fromApi(movie));
      // print("Wallpaper " + returnMovies.last.title);
    }
    return returnMovies;
  }

  Future<List<Movie>> getMoviesOfGenre(String genre) async {
    var movies = await collection.get();
    List<Movie> returnMovies = [];
    for (var movie
        in movies.docs.where((element) => element["Genre"].contains(genre))) {
      returnMovies.add(Movie.fromApi(movie));
      // print("Genre: " + returnMovies.last.title);
    }
    return returnMovies;
  }
}
