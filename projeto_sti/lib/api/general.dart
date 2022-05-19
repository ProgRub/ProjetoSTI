import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_sti/api/movies.dart';
import 'package:projeto_sti/api/persons.dart';
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
    var people = await PersonsAPI().getAllPeople();

    Map<String, Future<Image>> posters = {};

    for (var movie in movies) {
      results.add(movie);
      posters[movie.id] = movie.getPoster();
      // results.add(movie.title);
      // results.addAll(movie.cast);
      // results.addAll(movie.directors);
    }

    for (var tvShow in tvShows) {
      results.add(tvShow);
      posters[tvShow.id] = tvShow.getPoster();
      // results.add(tvShow.title);
      // results.addAll(tvShow.cast);
      // results.addAll(tvShow.writers);
    }

    for (var person in people) {
      results.add(person);
      // posters[person.id] = person.getPhoto();
      // results.add(tvShow.title);
      // results.addAll(tvShow.cast);
      // results.addAll(tvShow.writers);
    }

    // Set<String> sortedSet =
    //     SplayTreeSet.from(results, (a, b) => a.compareTo(b));

    return results;
  }
}
