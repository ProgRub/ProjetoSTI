import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  String id;
  int year;
  double rating;
  List<String> genres;
  String plot, title, poster, length, language, ageRating;
  List<String> cast, directors, writers;

  Movie(
      {required this.id,
      required this.year,
      required this.rating,
      required this.genres,
      required this.plot,
      required this.title,
      required this.poster,
      required this.cast,
      required this.length,
      required this.language,
      required this.ageRating,
      required this.directors,
      required this.writers});

  Movie.fromApi(QueryDocumentSnapshot<Map<String, dynamic>> apiResponse)
      : id = apiResponse.id,
        cast = apiResponse["Actors"],
        directors = apiResponse["Director"],
        genres = apiResponse["Genre"],
        rating = apiResponse["imdbRating"],
        year = apiResponse["Year"],
        plot = apiResponse["Plot"],
        title = apiResponse["Title"],
        language = apiResponse["Language"],
        length = apiResponse["Runtime"],
        ageRating = apiResponse["Rated"],
        poster = apiResponse["Poster"],
        writers = apiResponse["Writer"];
}
