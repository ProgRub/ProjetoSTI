import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/bottomAppBar.dart';
import 'package:projeto_sti/components/poster.dart';
import 'package:projeto_sti/models/person.dart';
import 'package:projeto_sti/models/tvShow.dart';
import 'package:projeto_sti/screens/tvShowInfoScreen.dart';
import 'package:projeto_sti/styles/style.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api/movies.dart';
import '../api/tvShows.dart';
import '../models/movie.dart';
import 'movieInfoScreen.dart';

class PersonInfoScreen extends StatefulWidget {
  PersonInfoScreen({Key? key, required this.artist}) : super(key: key);

  var artist;

  @override
  State<PersonInfoScreen> createState() => _PersonInfoState(artist);
}

class _PersonInfoState extends State<PersonInfoScreen> {
  late int selectedCategoryActor,
      selectedCategoryDirector,
      selectedCategoryWriter;
  final List<String> categories = ["Movies", "Tv Shows"];
  late Person artist;
  late Future<Map<String, List<Movie>>> moviesFuture;
  late Future<Map<String, List<TvShow>>> tvShowsFuture;
  late Map<String, List<Movie>> allMovies;
  late Map<String, List<TvShow>> allTvShows;

  _PersonInfoState(this.artist) {
    moviesFuture = MoviesAPI().getMoviesOfPerson(artist.id);
    tvShowsFuture = TVShowsAPI().getTvShowsOfPerson(artist.id);
    artist = artist;
    selectedCategoryActor = 0;
    selectedCategoryDirector = 0;
    selectedCategoryWriter = 0;
    super.initState();
  }
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var genreTitle = Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 30.0, bottom: 20.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          artist.name,
          style: Styles.fonts.title,
        ),
      ),
    );

    Padding makeMovieGrid(role) {
      return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
              height: 230,
              child: FutureBuilder(
                future: moviesFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, List<Movie>>> snapshot) {
                  Widget child;
                  child = const SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  );
                  if (snapshot.hasData) {
                    allMovies = snapshot.data!;
                    child = GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 4,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                      itemCount: allMovies[role]!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FutureBuilder(
                            future: allMovies[role]![index].getPoster(),
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
                                                MovieInfoScreen(
                                                    allMovies[role]![
                                                        index]),
                                          ));
                                    },
                                    child: snapshot.data!);
                              }
                              return child;
                            });
                      },
                    );
                  }
                  return child;
                },
              )));
    }

    Padding makeTvShowGrid(role) {
      return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
              height: 230,
              child: FutureBuilder(
                future: tvShowsFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, List<TvShow>>> snapshot) {
                  Widget child;
                  child = const SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  );
                  if (snapshot.hasData) {
                    allTvShows = snapshot.data!;
                    child = GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 4,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                      itemCount: allTvShows[role]!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FutureBuilder(
                            future: allTvShows[role]![index].getPoster(),
                            builder: (BuildContext context,
                                AsyncSnapshot<Image> snapshot) {
                              Widget child;
                              child = const SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(),
                              );
                              if (snapshot.hasData) {
                                child = snapshot.data!;
                                child = GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TvShowInfoScreen(
                                                    allTvShows[role]![index]),
                                          ));
                                    },
                                    child: snapshot.data!);
                              }
                              return child;
                            });
                      },
                    );
                  }
                  return child;
                },
              )));
    }

    //Method to create a tab
    GestureDetector createTab(index, context, personRole) {
      int selectedCategory = 0;
      switch (personRole) {
        case 0:
          selectedCategory = selectedCategoryActor;
          break;
        case 1:
          selectedCategory = selectedCategoryDirector;
          break;
        case 2:
          selectedCategory = selectedCategoryWriter;
          break;
        default:
      }
      return GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(categories[index],
                style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: index == selectedCategory
                        ? Styles.colors.purple
                        : Styles.colors.grey)),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: 6,
                width: 90,
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
              switch (personRole) {
                case 0:
                  selectedCategoryActor = index;
                  break;
                case 1:
                  selectedCategoryDirector = index;
                  break;
                case 2:
                  selectedCategoryWriter = index;
                  break;
                default:
              }
            },
          );
        },
      );
    }

    Padding tabsActor = Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 30.0),
      child: SizedBox(
        height: 70,
        child: Row(
          children: [
            ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => createTab(index, context, 0),
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 50,
                );
              },
            ),
          ],
        ),
      ),
    );

    Padding tabsDirector = Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 30.0),
      child: SizedBox(
        height: 70,
        child: Row(
          children: [
            ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => createTab(index, context, 1),
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 50,
                );
              },
            ),
          ],
        ),
      ),
    );

    Padding tabsWriter = Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 30.0),
      child: SizedBox(
        height: 70,
        child: Row(
          children: [
            ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => createTab(index, context, 2),
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 50,
                );
              },
            ),
          ],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                child: AppLogo(),
                alignment: Alignment.topLeft,
              ),
              genreTitle,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          FutureBuilder(
                            future: artist.getPhoto(),
                            builder: (BuildContext context,
                                AsyncSnapshot<Image> snapshot) {
                              if (snapshot.hasData) {
                                return Center(
                                  child: CircleAvatar(
                                    backgroundColor: Styles.colors.lightBlue,
                                    radius: 70.0,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      backgroundImage: snapshot.data!.image,
                                      radius: 66.0,
                                      child: CircleAvatar(
                                        backgroundColor: Styles.colors.darker,
                                        radius: 66.0,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Text("Born: ", style: Styles.fonts.label),
                          Text(artist.born, style: Styles.fonts.comment)
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text("Awards: ", style: Styles.fonts.label),
                          Text(artist.awardWins.toString(),
                              style: Styles.fonts.comment),
                          const SizedBox(width: 5),
                          const FaIcon(FontAwesomeIcons.trophy,
                              size: 15.0, color: Colors.yellow),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text("Nominations: ", style: Styles.fonts.label),
                          Text(artist.awardNominations.toString(),
                              style: Styles.fonts.comment),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  text: "Bio: ",
                                  style: Styles.fonts.label,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: artist.summary,
                                      style: Styles.fonts.comment,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              _buildTextLabel(
                  "Actor", Styles.fonts.title), //AJUSTAR DE ACORDO COM O GENERO
              tabsActor,
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                firstChild: makeMovieGrid("Actor"),
                secondChild: makeTvShowGrid("Actor"),
                crossFadeState: selectedCategoryActor == 0
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
              _buildTextLabel("Director", Styles.fonts.title),
              tabsDirector,
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                firstChild: makeMovieGrid("Director"),
                secondChild: makeTvShowGrid("Director"),
                crossFadeState: selectedCategoryDirector == 0
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
              _buildTextLabel("Writer", Styles.fonts.title),
              tabsWriter,
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                firstChild: makeMovieGrid("Writer"),
                secondChild: makeTvShowGrid("Writer"),
                crossFadeState: selectedCategoryWriter == 0
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildTextLabel(String text, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 30.0, bottom: 20.0),
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
