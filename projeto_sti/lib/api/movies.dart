import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_sti/api/persons.dart';
import 'package:projeto_sti/api/users.dart';
import 'package:projeto_sti/models/movie.dart';
import 'package:projeto_sti/models/person.dart';
import 'package:projeto_sti/models/tvShow.dart';

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
      // collection
      //     .doc(movie.id)
      //     .update({"timesFavourited": 0, "timesWatched": 0});
      returnMovies.add(Movie.fromApi(movie));
      if (returnMovies.last.cast.any((element) => element.contains(" "))) {
        List<String> actors = [];
        for (var actor in returnMovies.last.cast) {
          // print(actor);
          actors.add(await PersonsAPI().addPersonIfNotInDB(actor, "Actor"));
        }
        // if (returnMovies.last.title == "Se7en")
        // print(actors);
        if (actors.any((element) => element.isEmpty || element.contains(" ")))
          continue;
        // print("CHANGED ACTORS MOVIES");
        collection.doc(returnMovies.last.id).update({"Actors": actors});
        returnMovies.last.cast = actors;
      }
      if (returnMovies.last.directors.any((element) => element.contains(" "))) {
        List<String> directors = [];
        for (var director in returnMovies.last.directors) {
          directors
              .add(await PersonsAPI().addPersonIfNotInDB(director, "Director"));
        }
        if (directors.any(
            (element) => element.isEmpty || element.contains(" "))) continue;
        collection.doc(returnMovies.last.id).update({"Director": directors});
        returnMovies.last.directors = directors;
      }
      if (returnMovies.last.writers.any((element) => element.contains(" "))) {
        List<String> writers = [];
        for (var writer in returnMovies.last.writers) {
          writers.add(await PersonsAPI().addPersonIfNotInDB(writer, "Writer"));
        }
        if (writers.any((element) => element.isEmpty || element.contains(" ")))
          continue;
        collection.doc(returnMovies.last.id).update({"Writer": writers});
        returnMovies.last.writers = writers;
      }
      // print("Wallpaper " + returnMovies.last.title);
    }
    print("FINISHED MOVIES");
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

  Future<Map<String, List<Movie>>> getMoviesOfPerson(String personId) async {
    List<Movie> actorMovies = [];
    List<Movie> directorMovies = [];
    List<Movie> writerMovies = [];
    var moviesAsActor =
        await collection.where('Actors', arrayContains: personId).get();
    for (var movie in moviesAsActor.docs) {
      actorMovies.add(Movie.fromApi(movie));
    }
    var moviesAsDirector =
        await collection.where('Director', arrayContains: personId).get();
    for (var movie in moviesAsDirector.docs) {
      directorMovies.add(Movie.fromApi(movie));
    }
    var moviesAsWriter =
        await collection.where('Writer', arrayContains: personId).get();
    for (var movie in moviesAsWriter.docs) {
      writerMovies.add(Movie.fromApi(movie));
    }
    // print(actorMovies);
    // print(directorMovies);
    // print(writerMovies);
    return {
      "Actor": actorMovies,
      "Director": directorMovies,
      "Writer": writerMovies
    };
  }

  void changeFavouriteCount(String id, int numTimes) async {
    int timesFavourited = (await collection.doc(id).get())["timesFavourited"];
    // print(timesFavourited.toString());
    collection
        .doc(id)
        .update({"timesFavourited": max(0, timesFavourited + numTimes)});
  }

  void changeWatchedCount(String id, int numTimes) async {
    int timesWatched = (await collection.doc(id).get())["timesWatched"];
    // print(timesWatched.toString());
    collection
        .doc(id)
        .update({"timesWatched": max(0, timesWatched + numTimes)});
  }

  Future<Movie?> getMovieById(String id) async {
    var doc = await collection.doc(id).get();
    if (doc.exists) {
      return Movie.fromApi(doc);
    }
    return null;
  }
}
