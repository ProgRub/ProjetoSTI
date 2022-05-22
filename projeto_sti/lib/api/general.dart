import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_sti/api/movies.dart';
import 'package:projeto_sti/api/persons.dart';
import 'package:projeto_sti/api/tvShows.dart';
import 'package:projeto_sti/models/movie.dart';
import 'package:projeto_sti/models/tvShow.dart';

class GeneralAPI {
  FirebaseFirestore firebase = FirebaseFirestore.instance;

  GeneralAPI._privateConstructor();

  static final GeneralAPI _instance = GeneralAPI._privateConstructor();

  factory GeneralAPI() {
    return _instance;
  }

  Future<Set<Object?>> getSearchTerms(Future<List<Movie>> moviesFuture,
      Future<List<TvShow>> tvShowsFuture) async {
    Set<Object?> results = {};
    var movies = await moviesFuture;
    var tvShows = await tvShowsFuture;
    var people = await PersonsAPI().getAllPeople(movies, tvShows);

    // Map<String, Future<Image>> posters = {};

    for (var movie in movies) {
      results.add(movie);
      // posters[movie.id] = movie.getPoster();
    }

    for (var tvShow in tvShows) {
      results.add(tvShow);
      // posters[tvShow.id] = tvShow.getPoster();
    }

    for (var person in people) {
      results.add(person);
    }

    return results;
  }
}
