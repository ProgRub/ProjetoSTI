import 'package:flutter/material.dart';
import 'package:projeto_sti/api/authentication.dart';
import 'package:projeto_sti/api/movies.dart';
import 'package:projeto_sti/api/tvShows.dart';
import 'package:projeto_sti/api/users.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/bottomAppBar.dart';
import 'package:projeto_sti/components/genreOval.dart';
import 'package:projeto_sti/components/popupMessage.dart';
import 'package:projeto_sti/components/poster.dart';
import 'package:projeto_sti/components/quarterCircle.dart';
import 'package:projeto_sti/models/movie.dart';
import 'package:projeto_sti/models/tvShow.dart';
import 'package:projeto_sti/screens/editProfileScreen.dart';
import 'package:projeto_sti/screens/movieInfoScreen.dart';
import 'package:projeto_sti/screens/tvShowInfoScreen.dart';
import 'package:projeto_sti/styles/style.dart';

import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

import 'loginScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  late int selectedCategory = 0;
  late List<String> sections;
  late List<GenreOval> genres;
  String usersName = UserAPI().loggedInUser!.name;

  late int numberFavourites;

  late Future<List<Movie>> moviesFuture;
  late Future<List<TvShow>> tvShowsFuture;
  late List<Movie> movies;
  late List<TvShow> tvShows;

  @override
  initState() {
    moviesFuture = MoviesAPI().getUserWatchedMovies();
    tvShowsFuture = TVShowsAPI().getUserWatchedTvShows();
    movies = <Movie>[];
    tvShows = <TvShow>[];
    sections = ["Movies", "Tv Shows"];
    genres = _favouriteGenres();
    numberFavourites = 0;
    super.initState();
  }

  int _countNumberFavourites() {
    return UserAPI().loggedInUser!.favouriteMovies.length +
        UserAPI().loggedInUser!.favouriteTvShows.length;
  }

  List<GenreOval> _favouriteGenres() {
    List<GenreOval> list = <GenreOval>[];
    for (var title in UserAPI().getGenrePreferences()) {
      list.add(GenreOval(text: title, color: _randomColor()));
    }
    return list;
  }

  SizedBox noWatchedMessage(String type) {
    return SizedBox(
      height: 200,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset("packages/projeto_sti/assets/images/popcorn.png",
              width: 80, height: 80),
          Text("You haven't watched any $type!", style: Styles.fonts.label)
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var moviesGrid = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: FutureBuilder(
          future: moviesFuture,
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            Widget child;
            child = const SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            );
            if (snapshot.hasData) {
              movies = snapshot.data!;
              child = GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 7 / 10,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15,
                    crossAxisCount: 2),
                itemCount: movies.length,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder(
                      future: movies[index].getPoster(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Image> snapshot) {
                        Widget child;
                        child = const SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(),
                        );
                        if (snapshot.hasData) {
                          child = GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MovieInfoScreen(movie: movies[index]),
                                    ));
                              },
                              child: snapshot.data!);
                        }
                        return child;
                      });
                },
              );
            }
            return movies.isEmpty ? noWatchedMessage("movie") : child;
          },
        ));

    var tvShowsGrid = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: FutureBuilder(
          future: tvShowsFuture,
          builder:
              (BuildContext context, AsyncSnapshot<List<TvShow>> snapshot) {
            Widget child;
            child = const SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            );
            if (snapshot.hasData) {
              tvShows = snapshot.data!;
              child = GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 7 / 10,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15,
                    crossAxisCount: 2),
                itemCount: tvShows.length,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder(
                      future: tvShows[index].getPoster(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Image> snapshot) {
                        Widget child;
                        child = const SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(),
                        );
                        if (snapshot.hasData) {
                          child = GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TvShowInfoScreen(tvShows[index]),
                                    ));
                              },
                              child: snapshot.data!);
                        }
                        return child;
                      });
                },
              );
            }
            return tvShows.isEmpty ? noWatchedMessage("tv show") : child;
          },
        ));

    GestureDetector createTab(index, context) {
      return GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sections[index],
                style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: index == selectedCategory
                        ? Styles.colors.purple
                        : Styles.colors.grey)),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: 6,
                width: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: index == selectedCategory
                        ? Styles.colors.purple
                        : Colors.transparent))
          ],
        ),
        onTap: () {
          setState(
            () {
              selectedCategory = index;
            },
          );
        },
      );
    }

    SizedBox tabs = SizedBox(
      height: 70,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: sections.length,
        itemBuilder: (context, index) => createTab(index, context),
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 50,
          );
        },
      ),
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Styles.colors.background,
        bottomNavigationBar: const AppBarBottom(currentIndex: 4),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              const AppLogo(),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ));
                  },
                  child: Stack(children: [
                    _buildQuarterCircle(140, Styles.colors.purple),
                    Padding(
                      padding: const EdgeInsets.only(top: 63, right: 43),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Transform.rotate(
                          angle: pi / 4,
                          child: Text('Edit Profile', style: Styles.fonts.edit),
                        ),
                      ),
                    ),
                  ])),
              _buildQuarterCircle(82, Styles.colors.blurred),
              GestureDetector(
                onTap: () {
                  Authentication().logout();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => const LoginScreen()));
                }, //PARA TESTAR
                child: Stack(children: [
                  _buildQuarterCircle(80, Colors.white),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Transform.rotate(
                        angle: pi / 4,
                        child: Text('Logout', style: Styles.fonts.logout),
                      ),
                    ),
                  ),
                ]),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTextLabel("Your Profile", Styles.fonts.title),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Styles.colors.lightBlue,
                            radius: 50.0,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                  UserAPI().loggedInUser!.imageDownloadUrl),
                              radius: 46.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Text(usersName, style: Styles.fonts.label),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(
                          _countNumberFavourites().toString(), "Favourites"),
                      _buildInfoSection(
                          UserAPI()
                              .loggedInUser!
                              .watchedMovies
                              .length
                              .toString(),
                          "Watched\n Movies"),
                      _buildInfoSection(
                          UserAPI()
                              .loggedInUser!
                              .watchedTvShows
                              .length
                              .toString(),
                          "Watched \nTv Shows"),
                    ],
                  ),
                  _buildTextLabel("Favourite Genres", Styles.fonts.label),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ...genres,
                    ],
                  ),
                  _buildTextLabel("Watched", Styles.fonts.label),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        tabs,
                      ],
                    ),
                  ),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 200),
                    firstChild: moviesGrid,
                    secondChild: tvShowsGrid,
                    crossFadeState: selectedCategory == 0
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _randomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  Padding _buildTextLabel(String text, TextStyle style) {
    return Padding(
      padding: style == Styles.fonts.title
          ? const EdgeInsets.only(top: 95.0, left: 30.0)
          : const EdgeInsets.only(top: 30.0, left: 30.0, bottom: 20.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          text,
          style: style,
        ),
      ),
    );
  }

  Column _buildInfoSection(String number, String label) {
    return Column(
      children: [
        Text(number, style: Styles.fonts.label),
        const SizedBox(height: 10.0),
        Text(
          label,
          style: Styles.fonts.placeholder,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  SizedBox _buildQuarterCircle(double height, Color color) {
    return SizedBox(
      height: height,
      child: QuarterCircle(
        color: color,
        circleAlignment: CircleAlignment.topRight,
      ),
    );
  }
}
