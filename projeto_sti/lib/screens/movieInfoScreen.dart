import 'dart:math';

import 'package:flutter/material.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/genreOval.dart';
import 'package:projeto_sti/styles/style.dart';

import 'package:like_button/like_button.dart';

class MovieInfoScreen extends StatefulWidget {
  const MovieInfoScreen({Key? key}) : super(key: key);

  @override
  State<MovieInfoScreen> createState() => _MovieInfoState();
}

class _MovieInfoState extends State<MovieInfoScreen> {
  late String movieTitle;
  late String rating;
  late String length;
  late String year;
  late String language;
  late String age;
  late String plot;
  late List<String> movieGenres;

  late List<GenreOval> genres;

  @override
  initState() {
    movieTitle = "Joker";
    rating = "8.4";
    length = "2h02m";
    year = "2019";
    language = "English";
    age = "M/14";
    movieGenres = ["Crime", "Drama", "Suspense"];
    plot =
        "Arthur Fleck works as a clown and is an aspiring stand-up comic. He has mental health issues, part of which involves uncontrollable laughter. Times are tough and, due to his issues and occupation, Arthur has an even worse time than most. Over time these issues bear down on him, shaping his actions, making him ultimately take on the persona he is more known as...Joker.";

    genres = _favouriteGenres();
    super.initState();
  }

  List<GenreOval> _favouriteGenres() {
    List<GenreOval> list = <GenreOval>[];
    for (var title in movieGenres) {
      list.add(GenreOval(text: title, color: _randomColor()));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var topSection = Stack(
      children: [
        Image.network(
            'https://images.hdqwalls.com/wallpapers/joker-2019-movie-4k-new-pw.jpg',
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover),
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Styles.colors.darker,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            AppLogo(),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: LikeButton(
                size: 50.0,
                onTap: onLikeButtonTapped,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 150.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Icon(
                  Icons.play_arrow,
                  size: 35.0,
                  color: Styles.colors.purple,
                ),
                onPressed: () {
                  print("PLAY TRAILER");
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  fixedSize: const Size(60, 60),
                  shape: const CircleBorder(),
                  side: BorderSide(
                    width: 3.0,
                    color: Styles.colors.purple,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 225.0),
          child: Center(child: Text(movieTitle, style: Styles.fonts.label)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 235.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child:
                  Icon(Icons.share_outlined, size: 50.0, color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(children: [
                Text(
                  rating,
                  style: Styles.fonts.rating,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                const Icon(Icons.star, size: 25.0, color: Colors.yellow),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Icon(Icons.check_circle,
                  size: 50.0, color: Styles.colors.grey),
            ),
          ]),
        ),
      ],
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Styles.colors.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              topSection,
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...genres,
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoColumn("Lenght", length),
                    _buildInfoColumn("Year", year),
                    _buildInfoColumn("Language", language),
                    _buildInfoColumn("Age", age),
                  ],
                ),
              ),
              _buildTextLabel("Plot", Styles.fonts.title),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35.0,
                  vertical: 10.0,
                ),
                child: Text(
                  plot,
                  style: Styles.fonts.plot,
                  textAlign: TextAlign.justify,
                ),
              ),
              _buildTextLabel("Videos", Styles.fonts.title),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildInfoColumn(String title, String value) {
    return Column(
      children: [
        Text(title, style: Styles.fonts.label),
        const SizedBox(
          height: 10.0,
        ),
        Text(value, style: Styles.fonts.rating),
      ],
    );
  }

  Padding _buildTextLabel(String text, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 30.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          text,
          style: style,
        ),
      ),
    );
  }
}

Color _randomColor() {
  return Colors.primaries[Random().nextInt(Colors.primaries.length)];
}

Future<bool> onLikeButtonTapped(bool isLiked) async {
  if (!isLiked) {
    print("LIKED");
  } else {
    print("DISLIKED");
  }
  return !isLiked;
}
