import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_sti/api/movies.dart';
import 'package:projeto_sti/api/tvShows.dart';

class GeneralAPI {
  FirebaseFirestore firebase = FirebaseFirestore.instance;

  GeneralAPI._privateConstructor();

  static final GeneralAPI _instance = GeneralAPI._privateConstructor();

  factory GeneralAPI() {
    return _instance;
  }

  Future<Set<Object?>> getSearchTerms() async {
    Set<Object?> results = {};
    var movies = await MoviesAPI().getAllMovies();
    var tvShows = await TVShowsAPI().getAllTvShows();
    // int index = 0;
    // print(movies.length);
    // print(tvShows.length);
    for (var movie in movies) {
      // index++;
      // print(movie.title);
      results.add(movie);
      // results.add(movie.title);
      // results.addAll(movie.cast);
      // results.addAll(movie.directors);
    }
    // print(index);
    // index = 0;

    for (var tvShow in tvShows) {
      // index++;
      // print(tvShow.title);
      results.add(tvShow);
      // results.add(tvShow.title);
      // results.addAll(tvShow.cast);
      // results.addAll(tvShow.writers);
    }
    // print(index);
    // Set<String> sortedSet =
    //     SplayTreeSet.from(results, (a, b) => a.compareTo(b));

    return results;
  }
}
