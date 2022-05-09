import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:projeto_sti/api/general.dart';
import 'package:projeto_sti/api/movies.dart';
import 'package:projeto_sti/api/tvShows.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/bottomAppBar.dart';
import 'package:projeto_sti/models/tvShow.dart';
import 'package:projeto_sti/screens/favouritesScreen.dart';
import 'package:projeto_sti/screens/genresScreen.dart';
import 'package:projeto_sti/screens/profileScreen.dart';
import 'package:projeto_sti/screens/topImdbScreen.dart';
import 'package:projeto_sti/screens/tvShowInfoScreen.dart';
import 'package:projeto_sti/styles/style.dart';
import 'package:getwidget/getwidget.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeletons/skeletons.dart';

import '../api/users.dart';
import '../models/movie.dart';
import 'movieInfoScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int selectedCategory = 0;
  late List<String> sections;
  String usersName = UserAPI().loggedInUser!.name;
  late final ScrollController _controller;
  bool visibleAppBar = false;
  final Future<List<Movie>> moviesFuture = MoviesAPI().getAllMovies();
  List<Movie> movies = [];
  final Future<List<TvShow>> tvShowsFuture = TVShowsAPI().getAllTvShows();
  List<TvShow> tvShows = [];

  @override
  initState() {
    sections = ["All", "Movies", "Tv Shows"];
    super.initState();
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.position.userScrollDirection == ScrollDirection.forward) {
        if (visibleAppBar && _controller.offset < 290) {
          setState(() {
            visibleAppBar = false;
          });
        }
      }
      if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
        if (!visibleAppBar && _controller.offset >= 290) {
          setState(() {
            visibleAppBar = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var skeletonPosterList = ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 6,
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

    var topMovies = Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 20.0,
        ),
        child: SizedBox(
            height: 230,
            child: FutureBuilder(
              future: moviesFuture,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
                Widget child;
                child = skeletonPosterList;

                if (snapshot.hasData) {
                  movies = snapshot.data!;
                  child = ListView.separated(
                      scrollDirection: Axis.horizontal,
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
                                                MovieInfoScreen(
                                                    movie: movies[index]),
                                          ));
                                    },
                                    child: snapshot.data!);
                              }
                              return child;
                            });
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          width: 20.0,
                        );
                      });
                }
                return child;
              },
            )));

    var topTvShows = Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 20.0,
        ),
        child: SizedBox(
            height: 230,
            child: FutureBuilder(
              future: tvShowsFuture,
              builder:
                  (BuildContext context, AsyncSnapshot<List<TvShow>> snapshot) {
                Widget child;
                child = skeletonPosterList;
                if (snapshot.hasData) {
                  tvShows = snapshot.data!;
                  child = ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: tvShows.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FutureBuilder(
                            future: tvShows[index].getPoster(),
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
                                child = snapshot.data!;
                                child = GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TvShowInfoScreen(
                                                    tvShows[index]),
                                          ));
                                    },
                                    child: snapshot.data!);
                              }
                              return child;
                            });
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          width: 20.0,
                        );
                      });
                }
                return child;
              },
            )));

    var recommendationSection = Container(
      width: MediaQuery.of(context).size.width - 60,
      height: 160,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        image: DecorationImage(
          image: AssetImage("packages/projeto_sti/assets/images/avatar.jpg"),
          fit: BoxFit.fill,
        ),
      ),
    );

    var buttonsSection = Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton(
            const Icon(Icons.favorite, size: 25.0),
            "Favourites",
            const FavouritesScreen(),
          ),
          _buildButton(
            const FaIcon(FontAwesomeIcons.trophy, size: 20.0),
            "Top iMDB",
            const TopImdbScreen(),
          ),
          _buildButton(
            const Icon(Icons.grid_view, size: 25.0),
            "Genres",
            const GenresScreen(),
          ),
          _buildButton(
            const Icon(Icons.person, size: 25.0),
            "Profile",
            const ProfileScreen(),
          ),
        ],
      ),
    );

    var topSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: "Hey ",
                style: Styles.fonts.title,
                children: [
                  TextSpan(text: "$usersName!", style: Styles.fonts.userName)
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text("Let's find cool things to watch", style: Styles.fonts.rating),
          ],
        ),
        Stack(
          children: [
            CircleAvatar(
              backgroundColor: Styles.colors.lightBlue,
              radius: 38.0,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage:
                    NetworkImage(UserAPI().loggedInUser!.imageDownloadUrl),
                radius: 34.0,
                child: CircleAvatar(
                  backgroundColor: Styles.colors.darker,
                  radius: 34.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
    var suggestions = {"Test", "Mafalda", "Ruben", "Mafalda 2"};
    var searchBar = Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
      child: TextField(
        autocorrect: false,
        enableSuggestions: false,
        style: Styles.fonts.commentName,
        decoration: InputDecoration(
          hintText: 'What are you looking for?',
          hintStyle: Styles.fonts.hintText,
          fillColor: Colors.black,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          prefixIcon:
              Icon(Icons.search, size: 30.0, color: Styles.colors.lightBlue),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(color: Styles.colors.lightBlue, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(color: Styles.colors.lightBlue, width: 2.0),
          ),
        ),
      ),
    );

    searchBar = Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
        child: FutureBuilder(
          future: GeneralAPI().getSearchTerms(),
          builder: (BuildContext context, AsyncSnapshot<Set<String>> snapshot) {
            Widget child;
            child = TextField(
              autocorrect: false,
              enableSuggestions: false,
              style: Styles.fonts.commentName,
              decoration: InputDecoration(
                hintText: 'What are you looking for?',
                hintStyle: Styles.fonts.hintText,
                fillColor: Colors.black,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                prefixIcon: Icon(Icons.search,
                    size: 30.0, color: Styles.colors.lightBlue),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide:
                      BorderSide(color: Styles.colors.lightBlue, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide:
                      BorderSide(color: Styles.colors.lightBlue, width: 2.0),
                ),
              ),
            );
            if (snapshot.hasData) {
              child = GFSearchBar(
                searchList: snapshot.data!.toList(),
                searchQueryBuilder: (query, list) => list.where((item) {
                  return item!
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase());
                }).toList(),
                overlaySearchListItemBuilder: (dynamic item) => Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                onItemSelected: (dynamic item) {
                  setState(() {
                    for (var movie in movies) {
                      if (movie.title == item) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieInfoScreen(movie: movie),
                            ));
                        return;
                      }
                    }
                    for (var tvShow in tvShows) {
                      if (tvShow.title == item) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TvShowInfoScreen(tvShow),
                            ));
                        return;
                      }
                    }
                    // for (var person in actors_directors_writers) {
                    //   if (person.name == item) {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => PersonInfoScreen(person),
                    //         ));
                    //     return;
                    //   }
                    // }
                  });
                },
                searchBoxInputDecoration: InputDecoration(
                  hintText: 'What are you looking for?',
                  hintStyle: Styles.fonts.hintText,
                  fillColor: Colors.black,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  prefixIcon: Icon(Icons.search,
                      size: 30.0, color: Styles.colors.lightBlue),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide:
                        BorderSide(color: Styles.colors.lightBlue, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide:
                        BorderSide(color: Styles.colors.lightBlue, width: 2.0),
                  ),
                ),
              );
            }
            return child;
          },
        ));

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Styles.colors.background,
        body: Stack(
          children: [
            Padding(
              padding: visibleAppBar
                  ? const EdgeInsets.only(bottom: 80.0)
                  : const EdgeInsets.only(bottom: 0.0),
              child: SingleChildScrollView(
                controller: _controller,
                child: Column(children: [
                  const Align(
                    child: AppLogo(),
                    alignment: Alignment.topLeft,
                  ),
                  topSection,
                  buttonsSection,
                  searchBar,
                  _buildTextLabel("Today's Recommendation", Styles.fonts.title),
                  recommendationSection,
                  _buildTextLabel("New Releases", Styles.fonts.title),
                  topTvShows, //apenas para testar layout
                  _buildTextLabel("Trending Now", Styles.fonts.title),
                  topMovies, //apenas para testar layout
                  _buildTextLabel("Top Movies", Styles.fonts.title),
                  topMovies,
                  _buildTextLabel("Top Tv Shows", Styles.fonts.title),
                  topTvShows,
                ]),
              ),
            ),
            visibleAppBar
                ? Visibility(
                    visible: visibleAppBar,
                    child: const Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AppBarBottom(currentIndex: 0),
                    ),
                  )
                : const SizedBox(width: 0.0),
          ],
        ),
      ),
    );
  }

  Column _buildButton(Widget? icon, String label, Widget state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: icon,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => state,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            side: BorderSide(color: Styles.colors.purple, width: 2.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            minimumSize: const Size(50.0, 50.0),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(label, style: Styles.fonts.comment),
      ],
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
