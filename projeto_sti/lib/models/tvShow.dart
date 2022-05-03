import 'package:cloud_firestore/cloud_firestore.dart';

class TvShow {
  String id;
  int seasons;
  double rating;
  List<String> genres;
  String plot, years, title, poster, length, language, ageRating;
  List<String> cast, directors, writers;

  TvShow({
    required this.id,
    required this.years,
    required this.seasons,
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
    required this.writers,
  });

  TvShow.fromApi(QueryDocumentSnapshot<Map<String, dynamic>> apiResponse)
      : id = apiResponse.id,
        years = apiResponse["Year"],
        seasons = apiResponse["totalSeasons"],
        rating = apiResponse["imdbRating"],
        genres = apiResponse["Genre"],
        plot = apiResponse["Plot"],
        title = apiResponse["Title"],
        poster = apiResponse["Poster"],
        cast = apiResponse["Actors"],
        length = apiResponse["Runtime"],
        language = apiResponse["Language"],
        ageRating = apiResponse["Rated"],
        directors = apiResponse["Director"],
        writers = apiResponse["Writer"];
}
