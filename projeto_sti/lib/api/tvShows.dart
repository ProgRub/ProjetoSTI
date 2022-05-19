import 'package:cloud_firestore/cloud_firestore.dart';
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
        var actors = [];
        for (var actor in tvShows.last.cast) {
          // print(actor);
          // PersonsAPI().addActorIfNotInDB(actor);
          actors.add(await PersonsAPI().addActorIfNotInDB(actor));
        }
        if (actors.any((element) => element.isEmpty)) continue;
        // print("CHANGED ACTORS TVSHOWS");
        // collection.doc(tvShows.last.id).update({"Actors": actors});
      }
      // print("Wallpaper " + tvShows.last.title);
    }
    print("FINISHED TVSHOWS");
    return tvShows;
  }

  Future<List<TvShow>> getTvShowsOfGenre(String genre) async {
    var tvShows = await collection.get();
    List<TvShow> returnTvShows = [];
    for (var tvShow
        in tvShows.docs.where((element) => element["Genre"].contains(genre))) {
      returnTvShows.add(TvShow.fromApi(tvShow));
      // print("Genre: " + returnTvShows.last.title);
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
}
