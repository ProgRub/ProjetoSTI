class Movie {
  int id, year;
  double rating;
  List<String> genres;
  String plot, title, poster, lenght, language, age, director;
  List<String> cast;

  Movie({
    required this.id,
    required this.year,
    required this.rating,
    required this.genres,
    required this.plot,
    required this.title,
    required this.poster,
    required this.cast,
    required this.lenght,
    required this.language,
    required this.age,
    required this.director,
  });
}

List<Movie> movies = [
  Movie(
    id: 1,
    title: "Joker",
    year: 2019,
    rating: 8.4,
    genres: ["Crime", "Drama", "Suspense"],
    plot:
        "Arthur Fleck works as a clown and is an aspiring stand-up comic. He has mental health issues, part of which involves uncontrollable laughter. Times are tough and, due to his issues and occupation, Arthur has an even worse time than most. Over time these issues bear down on him, shaping his actions, making him ultimately take on the persona he is more known as...Joker.",
    poster: "...",
    cast: ["Rick", "Angelina", "Sophia"],
    lenght: "2h02m",
    language: "English",
    age: "M/14",
    director: "Todd Phillips",
  ),
];
