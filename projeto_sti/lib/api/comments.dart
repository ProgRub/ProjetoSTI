import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_sti/api/users.dart';
import 'package:projeto_sti/models/comment.dart';

class CommentAPI {
  CommentAPI._privateConstructor();
  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection('comments');

  static final CommentAPI _instance = CommentAPI._privateConstructor();

  factory CommentAPI() {
    return _instance;
  }

  Future<List<Comment>> getComments(String idMovieTvshow) async {
    var comments = await collection.get();
    List<Comment> returnComments = [];

    for (var comment in comments.docs) {
      if (comment["id_movie_tvshow"] == idMovieTvshow) {
        returnComments.add(Comment.fromApi(comment));
      }
    }
    return returnComments;
  }

  Future deleteUserComments(String userId) async {
    var comments = await collection.get();
    for (var comment in comments.docs) {
      if (comment["id_user"] == UserAPI().loggedInUser!.authId) {
        await collection.doc(comment.id).delete();
      }
    }
  }

  Future<void> addComment(String comment, String idMovieTvshow, String idUser,
      String date, String rate) async {
    var comments = await collection.add({
      "comment": comment,
      "date": date,
      "id_movie_tvshow": idMovieTvshow,
      "id_user": idUser,
      "rate": rate
    });
  }
}
