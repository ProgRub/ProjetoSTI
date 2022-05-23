import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_sti/models/comment.dart';

class CommentAPI {
  CommentAPI._privateConstructor();
  CollectionReference<Map<String, dynamic>> collection =
  FirebaseFirestore.instance.collection('comments');

  static final CommentAPI _instance = CommentAPI._privateConstructor();

  factory CommentAPI() {
    return _instance;
  }

  Future<List<Comment>> getComments(String id_movie_tvshow) async {
    var comments = await collection.get();
    List<Comment> returnComments = [];

    for (var comment in comments.docs) {
      if (comment["id_movie_tvshow"] == id_movie_tvshow){
        returnComments.add(Comment.fromApi(comment));
      }
    }
    return returnComments;
  }
}
