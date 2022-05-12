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

  Future<Set<String>> getSearchTerms() async {
    Set<String> results = {};
    var movies = await MoviesAPI().getAllMovies();
    var tvShows = await TVShowsAPI().getAllTvShows();
    for (var movie in movies) {
      results.add(movie.title);
      results.addAll(movie.cast);
      results.addAll(movie.directors);
    }
    for (var tvShow in tvShows) {
      results.add(tvShow.title);
      results.addAll(tvShow.cast);
      results.addAll(tvShow.writers);
    }
    Set<String> sortedSet =
        SplayTreeSet.from(results, (a, b) => a.compareTo(b));

    return sortedSet;
  }
}
