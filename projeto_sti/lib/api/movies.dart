import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_sti/api/users.dart';
import 'package:projeto_sti/models/movie.dart';
import 'package:projeto_sti/models/tvShow.dart';

import 'package:http/http.dart' as http;

class MoviesAPI {
  MoviesAPI._privateConstructor();

  static final MoviesAPI _instance = MoviesAPI._privateConstructor();

  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection('movies');

  static const SIMILARITY_THRESHOLD = 0.6;

  factory MoviesAPI() {
    return _instance;
  }
  Future<List<Movie>> getAllMovies() async {
    var movies = await collection.get();
    List<Movie> returnMovies = [];
    for (var movie in movies.docs) {
      returnMovies.add(Movie.fromApi(movie));
      for (var actor in returnMovies.last.cast) {
        print(
            'https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&titles=' +
                actor.replaceAll(" ", "%20"));
        print(
            'https://en.wikipedia.org/wiki/List_of_awards_and_nominations_received_by_' +
                actor.replaceAll(" ", "_"));
      }
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

  Future<List<Movie>> getUserFavouriteMovies() async {
    var movies = await collection.get();
    List<Movie> returnMovies = [];

    for (var movie in movies.docs.where((element) =>
        UserAPI().loggedInUser!.favouriteMovies.contains(element.id))) {
      returnMovies.add(Movie.fromApi(movie));
    }
    return returnMovies;
  }

  Future<List<Movie>> getUserWatchedMovies() async {
    var movies = await collection.get();
    List<Movie> returnMovies = [];

    for (var movie in movies.docs.where((element) =>
        UserAPI().loggedInUser!.watchedMovies.contains(element.id))) {
      returnMovies.add(Movie.fromApi(movie));
    }
    return returnMovies;
  }

  Future<List<dynamic>> getMoviesLikeMovie(Movie movie) async {
    var movies = await collection.get();
    List<Movie> returnMovies = [];
    var movieGenres = movie.genres.toSet();
    for (var movieLike in movies.docs) {
      if (movieLike.id == movie.id) continue;
      Set genresMovieLike = (movieLike["Genre"]).toSet();
      if (genresMovieLike.intersection(movieGenres).length /
              genresMovieLike.length >=
          SIMILARITY_THRESHOLD) {
        returnMovies.add(Movie.fromApi(movieLike));
      }
    }
    return returnMovies;
  }

  Future<List<dynamic>> getMoviesLikeTvShow(TvShow show) async {
    var movies = await collection.get();
    List<Movie> returnMovies = [];
    var movieGenres = show.genres.toSet();
    for (var movieLike in movies.docs) {
      Set genresMovieLike = (movieLike["Genre"]).toSet();
      if (genresMovieLike.intersection(movieGenres).length /
              genresMovieLike.length >=
          SIMILARITY_THRESHOLD) {
        returnMovies.add(Movie.fromApi(movieLike));
      }
    }
    return returnMovies;
  }
}
