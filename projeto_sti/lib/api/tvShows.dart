import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_sti/models/tvShow.dart';

class TVShowsAPI {
  TVShowsAPI._privateConstructor();
  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection('tvShows');

  static final TVShowsAPI _instance = TVShowsAPI._privateConstructor();

  factory TVShowsAPI() {
    return _instance;
  }
  Future<List<TvShow>> getAllTvShows() async {
    var shows = await collection.get();
    List<TvShow> tvShows = [];
    for (var show in shows.docs) {
      tvShows.add(TvShow.fromApi(show));
      print("Wallpaper " + tvShows.last.title);
    }
    return tvShows;
  }
}
