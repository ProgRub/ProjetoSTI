import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_sti/api/persons.dart';
import 'package:projeto_sti/api/users.dart';
import 'package:projeto_sti/models/tvShow.dart';

import '../models/movie.dart';

class TVShowsAPI {
  TVShowsAPI._privateConstructor();
  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection('tvShows');

  static const SIMILARITY_THRESHOLD = 0.6;

  static final TVShowsAPI _instance = TVShowsAPI._privateConstructor();

  factory TVShowsAPI() {
    return _instance;
  }
  Future<List<TvShow>> getAllTvShows() async {
    var shows = await collection.get();
    List<TvShow> tvShows = [];
    for (var show in shows.docs) {
      tvShows.add(TvShow.fromApi(show));
      if (tvShows.last.cast.any((element) => element.contains(" "))) {
        List<String> actors = [];
        for (var actor in tvShows.last.cast) {
          actors.add(await PersonsAPI().addPersonIfNotInDB(actor, "Actor"));
        }
        if (actors.any((element) => element.isEmpty || element.contains(" "))) {
          continue;
        }
        collection.doc(tvShows.last.id).update({"Actors": actors});
        tvShows.last.cast = actors;
      }
      if (tvShows.last.directors.any((element) => element.contains(" "))) {
        List<String> directors = [];
        for (var director in tvShows.last.directors) {
          directors
              .add(await PersonsAPI().addPersonIfNotInDB(director, "Director"));
        }
        if (directors.any(
            (element) => element.isEmpty || element.contains(" "))) continue;
        collection.doc(tvShows.last.id).update({"Director": directors});
        tvShows.last.directors = directors;
      }
      if (tvShows.last.writers.any((element) => element.contains(" "))) {
        List<String> writers = [];
        for (var writer in tvShows.last.writers) {
          writers.add(await PersonsAPI().addPersonIfNotInDB(writer, "Writer"));
        }
        if (writers.any((element) => element.isEmpty || element.contains(" "))) {
          continue;
        }
        collection.doc(tvShows.last.id).update({"Writer": writers});
        tvShows.last.writers = writers;
      }
    }
    return tvShows;
  }

  Future<List<TvShow>> getTvShowsOfGenre(String genre) async {
    var tvShows = await collection.get();
    List<TvShow> returnTvShows = [];
    for (var tvShow
        in tvShows.docs.where((element) => element["Genre"].contains(genre))) {
      returnTvShows.add(TvShow.fromApi(tvShow));
    }
    return returnTvShows;
  }

  Future<List<TvShow>> getUserFavouriteTvShows() async {
    var tvShows = await collection.get();
    List<TvShow> returntvShows = [];

    for (var tvShow in tvShows.docs.where((element) =>
        UserAPI().loggedInUser!.favouriteTvShows.contains(element.id))) {
      returntvShows.add(TvShow.fromApi(tvShow));
    }
    return returntvShows;
  }

  Future<List<TvShow>> getUserWatchedTvShows() async {
    var tvShows = await collection.get();
    List<TvShow> returntvShows = [];

    for (var tvShow in tvShows.docs.where((element) =>
        UserAPI().loggedInUser!.watchedTvShows.contains(element.id))) {
      returntvShows.add(TvShow.fromApi(tvShow));
    }
    return returntvShows;
  }

  Future<List<dynamic>> getTvShowsLikeMovie(Movie movie) async {
    var shows = await collection.get();
    List<TvShow> returnShows = [];
    var showGenres = movie.genres.toSet();
    for (var tvShowLike in shows.docs) {
      Set genresShowLike = (tvShowLike["Genre"]).toSet();
      if (genresShowLike.intersection(showGenres).length /
              genresShowLike.length >=
          SIMILARITY_THRESHOLD) {
        returnShows.add(TvShow.fromApi(tvShowLike));
      }
    }
    return returnShows;
  }

  Future<List<dynamic>> getTvShowsLikeTvShow(TvShow show) async {
    var shows = await collection.get();
    List<TvShow> returnShows = [];
    var showGenres = show.genres.toSet();
    for (var tvShowLike in shows.docs) {
      Set genreShowLike = (tvShowLike["Genre"]).toSet();
      if (genreShowLike.intersection(showGenres).length /
              genreShowLike.length >=
          SIMILARITY_THRESHOLD) {
        returnShows.add(TvShow.fromApi(tvShowLike));
      }
    }
    return returnShows;
  }

  Future<Map<String, List<TvShow>>> getTvShowsOfPerson(String personId) async {
    List<TvShow> actorTvShows = [];
    List<TvShow> directorTvShows = [];
    List<TvShow> writerTvShows = [];
    var tvShowsAsActor =
        await collection.where('Actors', arrayContains: personId).get();
    for (var movie in tvShowsAsActor.docs) {
      actorTvShows.add(TvShow.fromApi(movie));
    }
    var tvShowsAsDirector =
        await collection.where('Director', arrayContains: personId).get();
    for (var movie in tvShowsAsDirector.docs) {
      directorTvShows.add(TvShow.fromApi(movie));
    }
    var tvShowsAsWriter =
        await collection.where('Writer', arrayContains: personId).get();
    for (var movie in tvShowsAsWriter.docs) {
      writerTvShows.add(TvShow.fromApi(movie));
    }
    // print(actorTvShows);
    // print(directorTvShows);
    // print(writerTvShows);
    return {
      "Actor": actorTvShows,
      "Director": directorTvShows,
      "Writer": writerTvShows
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
}
