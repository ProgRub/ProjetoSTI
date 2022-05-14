import 'package:flutter/material.dart';
import 'package:projeto_sti/api/genres.dart';
import 'package:projeto_sti/api/movies.dart';
import 'package:projeto_sti/api/tvShows.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/bottomAppBar.dart';
import 'package:projeto_sti/models/tvShow.dart';
import 'package:projeto_sti/screens/movieInfoScreen.dart';
import 'package:projeto_sti/screens/tvShowInfoScreen.dart';
import 'package:projeto_sti/styles/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletons/skeletons.dart';

import '../models/genre.dart';
import '../models/movie.dart';

class TopImdbScreen extends StatefulWidget {
  const TopImdbScreen({Key? key}) : super(key: key);

  @override
  State<TopImdbScreen> createState() => _TopImdbState();
}

class _TopImdbState extends State<TopImdbScreen> {
  late int selectedCategory;
  final List<String> categories = ["Movies", "Tv Shows"];
  String filterValue = "All";
  Future<List<Genre>> genresFuture = GenresAPI().getAllGenres();
  Future<List<Movie>> moviesFuture = MoviesAPI().getAllMovies();
  Future<List<TvShow>> tvShowsFuture = TVShowsAPI().getAllTvShows();
  List<Genre> genres = [];
  List<Movie> movies = [];
  List<TvShow> tvShows = [];
  List<String> filters = [];

  @override
  initState() {
    selectedCategory = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var skeletonPosterList = ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return const SkeletonItem(
          child: SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: 155,
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          width: 20.0,
        );
      },
    );

    var pageTitle = Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 30.0, bottom: 20.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Top iMDB",
          style: Styles.fonts.title,
        ),
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

    var filterRow = Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Row(
        children: [
          Text("Filter:", style: Styles.fonts.label),
          const SizedBox(width: 10.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: FutureBuilder(
                future: genresFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Genre>> snapshot) {
                  if (snapshot.hasData && filters.isEmpty) {
                    var genres = snapshot.data!;
                    for (var genre in genres) {
                      filters.add(genre.name);
                    }
                    filters.sort(
                        (a, b) => a.compareTo(b)); //ordena alfabeticamente
                    filters.insert(0, "All");
                  }
                  return DropdownButton<String>(
                    focusColor: Colors.transparent,
                    value: filterValue,
                    isDense: true,
                    style: Styles.fonts.plot,
                    onChanged: (String? newFilter) {
                      setState(() {
                        filterValue = newFilter!;
                        if (filterValue == "All") {
                          moviesFuture = MoviesAPI().getAllMovies();
                          tvShowsFuture = TVShowsAPI().getAllTvShows();
                        } else {
                          moviesFuture =
                              MoviesAPI().getMoviesOfGenre(filterValue);
                          tvShowsFuture =
                              TVShowsAPI().getTvShowsOfGenre(filterValue);
                        }
                      });
                    },
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Colors.transparent),
                    iconSize: 0,
                    underline: const SizedBox(),
                    items:
                        filters.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );

    var moviesList = FutureBuilder(
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
          movies.sort((a, b) => b.rating.compareTo(a
              .rating)); //ordena por rating, b compareTo a para ordem descendente
          child = ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: movies.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return FutureBuilder(
                    future: movies[index].getPoster(),
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
                        var movie = movies[index];
                        child = _buildMovieRow(index, movie.title, movie.rating,
                            snapshot.data!, 0);
                      }
                      return child;
                    });
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 30.0,
                );
              });
        }
        return child;
      },
    );
    var tvShowsList = FutureBuilder(
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
          tvShows.sort((a, b) => b.rating.compareTo(a
              .rating)); //ordena por rating, b compareTo a para ordem descendente
          tvShows.reversed;
          child = ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: tvShows.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
                        var tvShow = tvShows[index];
                        child = _buildMovieRow(index, tvShow.title,
                            tvShow.rating, snapshot.data!, 1);
                      }
                      return child;
                    });
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 30.0,
                );
              });
        }
        return child;
      },
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Styles.colors.background,
        bottomNavigationBar: const AppBarBottom(currentIndex: 2),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  child: AppLogo(),
                  alignment: Alignment.topLeft,
                ),
                pageTitle,
                tabs,
                filterRow,
                const SizedBox(height: 30.0),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 0),
                  firstChild: moviesList,
                  secondChild: tvShowsList,
                  crossFadeState: selectedCategory == 0
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildMovieRow(
      int index, String title, num rating, Image poster, int type) {
    var place = index + 1;
    return GestureDetector(
      onTap: () {
        print(title);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => type == 0
                ? MovieInfoScreen(movie: movies[index])
                : TvShowInfoScreen(tvShows[index]),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SizedBox(
          height: 70,
          child: Card(
            elevation: 0,
            color: Styles.colors.background,
            child: ListTile(
              leading: Container(
                width: 40,
                height: 70,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: poster.image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              title: Text("#$place - $title", style: Styles.fonts.commentName),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(rating.toString(), style: Styles.fonts.comment),
                  const SizedBox(width: 5.0),
                  const Icon(
                    Icons.star,
                    size: 18.0,
                    color: Colors.yellow,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
