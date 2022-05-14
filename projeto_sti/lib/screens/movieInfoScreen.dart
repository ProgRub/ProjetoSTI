import 'dart:math';

import 'package:flutter/material.dart';
import 'package:projeto_sti/api/genres.dart';
import 'package:projeto_sti/api/users.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/bottomAppBar.dart';
import 'package:projeto_sti/components/genreOval.dart';
import 'package:projeto_sti/components/poster.dart';
import 'package:projeto_sti/styles/style.dart';
import 'package:projeto_sti/models/movie.dart';

import 'package:like_button/like_button.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/genre.dart';

class MovieInfoScreen extends StatefulWidget {
  final Movie movie;
  const MovieInfoScreen({Key? key, required this.movie}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MovieInfoState(movie);
}

class _MovieInfoState extends State<MovieInfoScreen> {
  late YoutubePlayerController _videoController;
  bool playingTrailer = false;
  late String trailerUrl;

  late bool watched;
  final Movie movie;

  late bool favourited;

  _MovieInfoState(this.movie);

  @override
  void initState() {
    trailerUrl = 'https://www.youtube.com/watch?v=' + movie.trailer;
    favourited = UserAPI().loggedInUser!.favouriteMovies.contains(movie.id);
    watched = UserAPI().loggedInUser!.watchedMovies.contains(movie.id);
    _videoController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(trailerUrl)!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        loop: false,
      ),
    );
    super.initState();
  }

  @override
  void deactivate() {
    _videoController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    var snackBar;

    if (!isLiked && !favourited) {
      favourited = !favourited;
      snackBar = SnackBar(content: Text(movie.title + " added to Favourites."));
      await UserAPI().setFavouriteTvShowOrMovie("movie", movie.id.toString());
    } else if (isLiked && favourited) {
      favourited = !favourited;
      snackBar =
          SnackBar(content: Text(movie.title + " removed from Favourites."));
      await UserAPI()
          .removeFavouriteTvShowOrMovie("movie", movie.id.toString());
    }

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {});
    return !isLiked;
  }

  Future<void> onWatchedButtonTapped() async {
    var snackBar;
    if (!watched) {
      snackBar =
          SnackBar(content: Text(movie.title + " added to Watched Movies."));
      await UserAPI().setWatchedTvShowOrMovie("movie", movie.id.toString());
      setState(() {
        watched = true;
      });
    } else {
      snackBar = SnackBar(
          content: Text(movie.title + " removed from Watched Movies."));
      await UserAPI().removeWatchedTvShowOrMovie("movie", movie.id.toString());
      setState(() {
        watched = false;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    var topSection = Stack(
      children: [
        FutureBuilder(
            future: movie.getWallpaper(300),
            builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
              Widget child;
              child = const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              );
              if (snapshot.hasData) {
                child = snapshot.data!;
              }
              return child;
            }),
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Styles.colors.darker,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppLogo(),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: LikeButton(
                isLiked: favourited,
                size: 40.0,
                onTap: onLikeButtonTapped,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 140.0),
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
                  setState(() {
                    _videoController.seekTo(Duration.zero);
                    playingTrailer = true;
                    _videoController.play();
                  });
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
          padding: const EdgeInsets.only(top: 210.0),
          child: Center(child: Text(movie.title, style: Styles.fonts.title)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 240.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child:
                  Icon(Icons.share_outlined, size: 40.0, color: Colors.white),
            ),
            Container(
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                color: Styles.colors.darker,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(children: [
                Text(
                  movie.rating.toString(),
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
              child: IconButton(
                icon: Icon(Icons.check_circle,
                    size: 40.0,
                    color: watched ? Styles.colors.watched : Colors.grey),
                onPressed: () {
                  setState(
                    () {
                      onWatchedButtonTapped();
                    },
                  );
                },
              ),
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
        movie.plot,
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
                  width: 220,
                  height: 130,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Styles.colors.purple,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    image: const DecorationImage(
                      image: AssetImage(
                          "packages/projeto_sti/assets/images/joker_image.png"),
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
    var genresSection = FutureBuilder(
        future: GenresAPI().getGenresByName(movie.genres),
        builder: (BuildContext context, AsyncSnapshot<List<Genre>> snapshot) {
          List<GenreOval> list = <GenreOval>[];
          if (snapshot.hasData) {
            for (var genre in snapshot.data!) {
              list.add(GenreOval(genre: genre));
            }
          }
          return Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: list,
            ),
          );
        });

    var infoSection = Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildInfoColumn("Length", movie.length),
          _buildInfoColumn("Year", movie.year.toString()),
          _buildInfoColumn("Language", movie.language),
          _buildInfoColumn("Age", movie.ageRating),
        ],
      ),
    );

    var photosSection = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 20.0,
      ),
      child: SizedBox(
        height: 160,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: 220,
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Styles.colors.lightBlue,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                image: const DecorationImage(
                  image: AssetImage(
                      "packages/projeto_sti/assets/images/joker_image.png"),
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
                        backgroundImage: AssetImage(
                            "packages/projeto_sti/assets/images/joaquin_phoenix.jpg"),
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

    var directorSection = Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 40.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          movie.directors.join(", "),
          style: Styles.fonts.plot,
        ),
      ),
    );

    var commentsSection = Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 30.0,
            left: 20.0,
            right: 20.0,
          ),
          child: SizedBox(
            height: 200,
            child: ListView.separated(
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Styles.colors.lightBlue,
                          child: const CircleAvatar(
                            radius: 28.0,
                            backgroundImage: AssetImage(
                                "packages/projeto_sti/assets/images/profile_pic.jpg"),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Joaquin Phoenix",
                              style: Styles.fonts.commentName,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text("I totally recommend it!",
                                style: Styles.fonts.comment),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text("9/10", style: Styles.fonts.comment),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                const Icon(Icons.star,
                                    size: 20.0, color: Colors.yellow),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 20.0,
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 30.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text("Share your opinion", style: Styles.fonts.button),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  primary: Styles.colors.button,
                  minimumSize: const Size(260, 50),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
    var moreLikeThisSection = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 20.0,
      ),
      child: SizedBox(
        height: 230,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Poster(type: 1);
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
        bottomNavigationBar: const AppBarBottom(currentIndex: 3),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  playingTrailer
                      ? Stack(
                          children: [
                            SizedBox(
                              width: 400,
                              height: 300,
                              child: YoutubePlayer(
                                controller: _videoController,
                                showVideoProgressIndicator: true,
                                progressColors: ProgressBarColors(
                                    playedColor: Styles.colors.lightBlue,
                                    handleColor: Styles.colors.lightBlue,
                                    backgroundColor: Colors.white),
                                onReady: () {},
                                onEnded: (data) {
                                  setState(() {
                                    playingTrailer = false;
                                    _videoController.pause();
                                  });
                                },
                                topActions: <Widget>[
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      movie.title + " - Trailer",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Container(
                                    width: 47,
                                    height: 47,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffF4F6FD),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          playingTrailer = false;
                                          _videoController.pause();
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : topSection,
                ],
              ),
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
              directorSection,
              _buildTitle("Comments"),
              commentsSection,
              _buildTitle("More like " + movie.title),
              moreLikeThisSection,
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
        Text(value, style: Styles.fonts.plot),
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
