import 'dart:math';

import 'package:flutter/material.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/genreOval.dart';
import 'package:projeto_sti/styles/style.dart';
import 'package:projeto_sti/models/movie.dart';

import 'package:like_button/like_button.dart';

class MovieInfoScreen extends StatefulWidget {
  const MovieInfoScreen({Key? key}) : super(key: key);

  @override
  State<MovieInfoScreen> createState() => _MovieInfoState();
}

class _MovieInfoState extends State<MovieInfoScreen> {
  late List<GenreOval> genres;

  @override
  initState() {
    genres = _favouriteGenres();
    super.initState();
  }

  List<GenreOval> _favouriteGenres() {
    List<GenreOval> list = <GenreOval>[];
    for (var title in movies[0].genres) {
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
                size: 40.0,
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
          child:
              Center(child: Text(movies[0].title, style: Styles.fonts.title)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 235.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child:
                  Icon(Icons.share_outlined, size: 40.0, color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(children: [
                Text(
                  movies[0].rating.toString(),
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
                  size: 40.0, color: Styles.colors.grey),
            ),
          ]),
        ),
      ],
    );

    var plotSection = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 35.0,
        vertical: 10.0,
      ),
      child: Text(
        movies[0].plot,
        style: Styles.fonts.plot,
        textAlign: TextAlign.justify,
      ),
    );

    var videosSection = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 20.0,
      ),
      child: SizedBox(
        height: 130,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: [
                Container(
                  width: 240,
                  height: 130,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Styles.colors.purple,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    image: const DecorationImage(
                      image: AssetImage(
                          "packages/projeto_sti/assets/images/profile.jpg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: Icon(
                        Icons.play_arrow,
                        size: 35.0,
                        color: Styles.colors.purple,
                      ),
                      onPressed: () {
                        print("PLAY VIDEO");
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        fixedSize: const Size(50, 50),
                        shape: const CircleBorder(),
                        side: BorderSide(
                          width: 3.0,
                          color: Styles.colors.purple,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              width: 20.0,
            );
          },
        ),
      ),
    );

    var genresSection = Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ...genres,
        ],
      ),
    );

    var infoSection = Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildInfoColumn("Lenght", movies[0].lenght),
          _buildInfoColumn("Year", movies[0].year.toString()),
          _buildInfoColumn("Language", movies[0].language),
          _buildInfoColumn("Age", movies[0].age),
        ],
      ),
    );

    var photosSection = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 20.0,
      ),
      child: SizedBox(
        height: 180,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: 240,
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Styles.colors.lightBlue,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                image: const DecorationImage(
                  image: AssetImage(
                      "packages/projeto_sti/assets/images/profile.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              width: 20.0,
            );
          },
        ),
      ),
    );

    var castSection = Padding(
      padding: const EdgeInsets.only(
        top: 30.0,
        left: 20.0,
        right: 20.0,
      ),
      child: SizedBox(
        height: 150,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 52.0,
                      backgroundColor: Styles.colors.button,
                      child: const CircleAvatar(
                        radius: 50.0,
                        backgroundImage: NetworkImage(
                            "https://www.revistabula.com/wp/wp-content/uploads/2019/12/Joaquin-Phoenix-610x350.jpg.webp"),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 13.0),
                  child: Text("Joaquin Phoenix",
                      style: Styles.fonts.plot, textAlign: TextAlign.center),
                ),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              width: 20.0,
            );
          },
        ),
      ),
    );
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Styles.colors.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              topSection,
              genresSection,
              infoSection,
              _buildTitle("Plot"),
              plotSection,
              _buildTitle("Videos"),
              videosSection,
              _buildTitle("Photos"),
              photosSection,
              _buildTitle("Cast"),
              castSection,
              _buildTitle("Director"),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 40.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Todd Phillips",
                    style: Styles.fonts.plot,
                  ),
                ),
              ),
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

  Padding _buildTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 30.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          text,
          style: Styles.fonts.title,
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
