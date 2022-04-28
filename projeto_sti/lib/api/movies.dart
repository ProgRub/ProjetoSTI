import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_sti/models/movie.dart';

class MoviesAPI {
  MoviesAPI._privateConstructor();

  static final MoviesAPI _instance = MoviesAPI._privateConstructor();

  CollectionReference movies = FirebaseFirestore.instance.collection('movies');

  factory MoviesAPI() {
    return _instance;
  }

  Future<List<Movie>> getAllMovies() {
    movies.get();
    return Future.value();
  }
}
