import 'package:flutter/material.dart';
import 'package:projeto_sti/api/movies.dart';
import 'package:projeto_sti/api/tvShows.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/bottomAppBar.dart';
import 'package:projeto_sti/components/poster.dart';
import 'package:projeto_sti/models/genre.dart';
import 'package:projeto_sti/models/tvShow.dart';
import 'package:projeto_sti/screens/tvShowInfoScreen.dart';
import 'package:projeto_sti/styles/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletons/skeletons.dart';

import '../models/movie.dart';
import 'movieInfoScreen.dart';

class ByGenreScreen extends StatefulWidget {
  const ByGenreScreen({Key? key, required this.genre}) : super(key: key);

  final Genre genre;

  @override
  State<ByGenreScreen> createState() => _ByGenreState(genre);
}

class _ByGenreState extends State<ByGenreScreen> {
  late int selectedCategory;
  final List<String> categories = ["Movies", "Tv Shows"];
  final Genre genre;
  late Future<List<Movie>> moviesFuture;
  late Future<List<TvShow>> tvShowsFuture;
  late List<Movie> movies;
  late List<TvShow> tvShows;

  _ByGenreState(this.genre) {
    moviesFuture = MoviesAPI().getMoviesOfGenre(genre.name);
    tvShowsFuture = TVShowsAPI().getTvShowsOfGenre(genre.name);
    selectedCategory = 0;
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
          widget.genre.name,
          style: Styles.fonts.title,
        ),
      ),
    );

    var moviesGrid = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                        child = const SkeletonItem(
                          child: SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              width: 155,
                            ),
                          ),
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
            return child;
          },
        ));

    var tvShowsGrid = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: FutureBuilder(
        future: tvShowsFuture,
        builder: (BuildContext context, AsyncSnapshot<List<TvShow>> snapshot) {
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
                  builder:
                      (BuildContext context, AsyncSnapshot<Image> snapshot) {
                    Widget child;
                    child = const SkeletonItem(
                      child: SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                          width: 155,
                        ),
                      ),
                    );
                    if (snapshot.hasData) {
                      child = snapshot.data!;
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
                  },
                );
              },
            );
          }
          return child;
        },
      ),
    );

    //Method to create a tab
    GestureDetector createTab(index, context) {
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
              selectedCategory = index;
            },
          );
        },
      );
    }

    Padding tabs = Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 30.0),
      child: SizedBox(
        height: 70,
        child: Row(
          children: [
            ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => createTab(index, context),
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
              tabs,
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
        ),
      ),
    );
  }

  GestureDetector _buildPoster(int index, int type) {
    return GestureDetector(
      onTap: () {
        print("POSTER CLICKED");
      },
      child: Poster(type: type),
    );
  }
}
