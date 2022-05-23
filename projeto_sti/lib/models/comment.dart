import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class Comment {
  String id,
      movieTvshowId,
      userId,
      rate,
      comment,
      date;

  Comment({
    required this.id,
    required this.movieTvshowId,
    required this.userId,
    required this.rate,
    required this.comment,
    required this.date,
});

  Comment.fromApi(QueryDocumentSnapshot<Map<String, dynamic>> apiResponse)
      : id = apiResponse.id,
        movieTvshowId = apiResponse["id_movie_tvshow"],
        userId = apiResponse["id_user"],
        rate = apiResponse["rate"],
        comment = apiResponse["comment"],
        date = apiResponse["date"];
}