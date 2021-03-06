import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:projeto_sti/api/general.dart';
import 'package:projeto_sti/api/movies.dart';
import 'package:projeto_sti/api/persons.dart';
import 'package:projeto_sti/api/tvShows.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/bottomAppBar.dart';
import 'package:projeto_sti/models/person.dart';
import 'package:projeto_sti/models/tvShow.dart';
import 'package:projeto_sti/screens/favouritesScreen.dart';
import 'package:projeto_sti/screens/genresScreen.dart';
import 'package:projeto_sti/screens/personInfoScreen.dart';
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
  String usersName = UserAPI().loggedInUser!.name;
  late final ScrollController _controller;
  bool visibleAppBar = false;
  Future<List<Movie>> moviesFuture = MoviesAPI().getAllMovies();
  List<Movie> movies = [];
  Future<List<TvShow>> tvShowsFuture = TVShowsAPI().getAllTvShows();
  List<TvShow> tvShows = [];
  late Future<List<Object>> programsCombinedFuture = combineMoviesTvShows();
  List<Object> programsCombined = [];
  late Future<Set<Object?>> searchTermsFuture =
      GeneralAPI().getSearchTerms(moviesFuture, tvShowsFuture);

  late Map<String, Future<Image>> posters;

  List<Person> people = [];

  final int AMOUNT_PROGRAMS_LOAD = 9;

  GlobalKey dataKey = GlobalKey();
  @override
  initState() {
    posters = {};

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

    var newReleasesSection = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 20.0,
      ),
      child: SizedBox(
        height: 230,
        child: FutureBuilder(
          future: programsCombinedFuture,
          builder:
              (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
            Widget child;
            child = skeletonPosterList;
            if (snapshot.hasData) {
              programsCombined = snapshot.data!;
              programsCombined.sort(((a, b) {
                Movie movieA, movieB;
                TvShow showA, showB;
                if (a.runtimeType == Movie) {
                  movieA = a as Movie;
                  if (b.runtimeType == Movie) {
                    movieB = b as Movie;
                    return movieB.year.compareTo(movieA.year);
                  } else {
                    showB = b as TvShow;
                    var yearShow = 2023;
                    var yearSplit = showB.years.split('???');
                    if (yearSplit.length == 1) {
                      yearShow = int.parse(yearSplit.first);
                    } else {
                      if (int.tryParse(yearSplit.last) != null) {
                        yearShow = int.parse(yearSplit.last);
                      }
                    }
                    return yearShow.compareTo(movieA.year);
                  }
                } else {
                  showA = a as TvShow;
                  var yearShowA = 2023;
                  var yearSplitA = showA.years.split('???');
                  if (yearSplitA.length == 1) {
                    yearShowA = int.parse(yearSplitA.first);
                  } else {
                    if (int.tryParse(yearSplitA.last) != null) {
                      yearShowA = int.parse(yearSplitA.last);
                    }
                  }
                  if (b.runtimeType == Movie) {
                    movieB = b as Movie;
                    return movieB.year.compareTo(yearShowA);
                  } else {
                    showB = b as TvShow;
                    var yearShowB = 2023;
                    var yearSplitB = showB.years.split('???');
                    if (yearSplitB.length == 1) {
                      yearShowB = int.parse(yearSplitB.first);
                    } else {
                      if (int.tryParse(yearSplitB.last) != null) {
                        yearShowB = int.parse(yearSplitB.last);
                      }
                    }
                    return yearShowB.compareTo(yearShowA);
                  }
                }
              }));
              var newReleases =
                  programsCombined.take(AMOUNT_PROGRAMS_LOAD).toList();
              child = ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: newReleases.length,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder(
                      future: newReleases[index].runtimeType == Movie
                          ? (newReleases[index] as Movie).getPoster()
                          : (newReleases[index] as TvShow).getPoster(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Image> snapshot2) {
                        Widget child;
                        child = const SkeletonItem(
                          child: SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              width: 155,
                            ),
                          ),
                        );
                        if (snapshot2.hasData) {
                          child = GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          newReleases[index].runtimeType ==
                                                  Movie
                                              ? MovieInfoScreen(
                                                  newReleases[index] as Movie)
                                              : TvShowInfoScreen(
                                                  newReleases[index] as TvShow),
                                    ));
                              },
                              child: snapshot2.data!);
                        }
                        return child;
                      });
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    width: 20.0,
                  );
                },
              );
            }
            return child;
          },
        ),
      ),
    );

    var trendingNowSection = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 20.0,
      ),
      child: SizedBox(
        height: 230,
        child: FutureBuilder(
          future: programsCombinedFuture,
          builder:
              (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
            Widget child;
            child = skeletonPosterList;
            if (snapshot.hasData) {
              programsCombined = snapshot.data!;
              programsCombined.sort(((a, b) {
                Movie movieA, movieB;
                TvShow showA, showB;
                if (a.runtimeType == Movie) {
                  movieA = a as Movie;
                  if (b.runtimeType == Movie) {
                    movieB = b as Movie;
                    return movieB.timesFavourited
                        .compareTo(movieA.timesFavourited);
                  } else {
                    showB = b as TvShow;
                    return showB.timesFavourited
                        .compareTo(movieA.timesFavourited);
                  }
                } else {
                  showA = a as TvShow;
                  if (b.runtimeType == Movie) {
                    movieB = b as Movie;
                    return movieB.timesFavourited
                        .compareTo(showA.timesFavourited);
                  } else {
                    showB = b as TvShow;
                    return showB.timesFavourited
                        .compareTo(showA.timesFavourited);
                  }
                }
              }));
              var trending =
                  programsCombined.take(AMOUNT_PROGRAMS_LOAD).toList();
              child = ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: trending.length,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder(
                      future: trending[index].runtimeType == Movie
                          ? (trending[index] as Movie).getPoster()
                          : (trending[index] as TvShow).getPoster(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Image> snapshot2) {
                        Widget child;
                        child = const SkeletonItem(
                          child: SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              width: 155,
                            ),
                          ),
                        );
                        if (snapshot2.hasData) {
                          child = GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          trending[index].runtimeType == Movie
                                              ? MovieInfoScreen(
                                                  trending[index] as Movie)
                                              : TvShowInfoScreen(
                                                  trending[index] as TvShow),
                                    ));
                              },
                              child: snapshot2.data!);
                        }
                        return child;
                      });
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    width: 20.0,
                  );
                },
              );
            }
            return child;
          },
        ),
      ),
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
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            Widget child;
            child = skeletonPosterList;
            if (snapshot.hasData) {
              movies = snapshot.data!;
              movies.sort(
                  ((a, b) => b.timesFavourited.compareTo(a.timesFavourited)));
              var topMovies = movies.take(AMOUNT_PROGRAMS_LOAD).toList();
              child = ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: topMovies.length,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder(
                      future: topMovies[index].getPoster(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Image> snapshot2) {
                        Widget child;
                        child = const SkeletonItem(
                          child: SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              width: 155,
                            ),
                          ),
                        );
                        if (snapshot2.hasData) {
                          child = GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MovieInfoScreen(topMovies[index]),
                                    ));
                              },
                              child: snapshot2.data!);
                        }
                        return child;
                      });
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    width: 20.0,
                  );
                },
              );
            }
            return child;
          },
        ),
      ),
    );

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
              tvShows.sort(
                  ((a, b) => b.timesFavourited.compareTo(a.timesFavourited)));
              var topTvShows = tvShows.take(AMOUNT_PROGRAMS_LOAD).toList();
              child = ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: topTvShows.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder(
                      future: topTvShows[index].getPoster(),
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
                                          TvShowInfoScreen(topTvShows[index]),
                                    ));
                              },
                              child: snapshot.data!);
                        }
                        return child;
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 20.0,
                    );
                  });
            }
            return child;
          },
        ),
      ),
    );

    var recommendationSection = SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      height: 160,
      child: FutureBuilder(
        future: UserAPI().getDailySuggestion(moviesFuture, tvShowsFuture),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          Widget child;
          child = SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: 160,
              height: MediaQuery.of(context).size.width - 60,
            ),
          );
          if (snapshot.hasData) {
            var program = snapshot.data!;
            child = FutureBuilder(
              future: program.runtimeType == Movie
                  ? program.getWallpaper(
                      160.0, MediaQuery.of(context).size.width - 60)
                  : program.getWallpaper(
                      160.0, MediaQuery.of(context).size.width - 60),
              builder: (BuildContext context, AsyncSnapshot<Image> snapshot2) {
                Widget child;
                child = SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    width: 160,
                    height: MediaQuery.of(context).size.width - 60,
                  ),
                );
                if (snapshot2.hasData) {
                  child = GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => program.runtimeType == Movie
                                ? MovieInfoScreen(program as Movie)
                                : TvShowInfoScreen(program as TvShow),
                          ));
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 60,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            image: DecorationImage(
                              image: snapshot2.data!.image,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 60,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Styles.colors.darker,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            border: Border.all(
                              width: 0.2,
                              color: Styles.colors.purple,
                            ),
                          ),
                        ),
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 100.0),
                          child: Text(program.title, style: Styles.fonts.label),
                        )),
                      ],
                    ),
                  );
                }
                return child;
              },
            );
          }
          return child;
        },
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
            "Top IMDb",
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
            Text("Let's find cool things to watch", style: Styles.fonts.plot),
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

    String _checkType(dynamic value) {
      if (value.runtimeType == Movie) return "Movie";
      if (value.runtimeType == TvShow) return "Tv Show";

      return (value as Person).type;
    }

    var searchBar = Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
        child: FutureBuilder(
          future: searchTermsFuture,
          builder:
              (BuildContext context, AsyncSnapshot<Set<Object?>> snapshot) {
            Widget child;
            child = TextField(
              textInputAction: TextInputAction.none,
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
                noItemsFoundWidget: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                            "packages/projeto_sti/assets/images/popcorn.png",
                            width: 40,
                            height: 40),
                        const SizedBox(height: 20.0),
                        Text("Oops! Couldn't find that!",
                            style: Styles.fonts.label),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
                searchQueryBuilder: (query, list) => list.where((item) {
                  Scrollable.ensureVisible(dataKey.currentContext!,
                      duration: const Duration(seconds: 1));
                  if (item!.runtimeType == Movie) {
                    Movie movie = item as Movie;
                    return movie.title
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase());
                  } else if (item.runtimeType == TvShow) {
                    TvShow tvShow = item as TvShow;
                    return tvShow.title
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase());
                  } else {
                    Person person = item as Person;
                    return person.name
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase());
                  }
                }).toList(),
                overlaySearchListItemBuilder: (dynamic item) {
                  String id;
                  String title = "";
                  List<String> actors = [];
                  String name = "";
                  String year = "";
                  if (item!.runtimeType == Movie) {
                    Movie movie = item as Movie;
                    id = movie.id;
                    title = movie.title;
                    year = movie.year.toString();
                    actors = movie.cast;
                    posters[movie.id] = movie.getPoster();
                  } else if (item!.runtimeType == TvShow) {
                    TvShow tvShow = item as TvShow;
                    id = tvShow.id;
                    title = tvShow.title;
                    if (tvShow.years.contains("???")) {
                      year = tvShow.years.split("???")[0];
                    } else {
                      year = tvShow.years;
                    }

                    actors = tvShow.cast;
                    posters[tvShow.id] = tvShow.getPoster();
                  } else {
                    Person person = item as Person;
                    people.add(person);
                    id = person.id;
                    name = person.name;
                    posters[person.id] = person.getPhoto();
                  }

                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Column(
                      children: [
                        Container(height: 1, color: Styles.colors.lightBlue),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            color: Colors.black,
                            child: ListTile(
                              leading: FutureBuilder(
                                future: posters[id],
                                builder: (BuildContext context,
                                    AsyncSnapshot<Image> snapshot) {
                                  Widget child;
                                  child = const SkeletonItem(
                                    child: SkeletonAvatar(
                                      style: SkeletonAvatarStyle(
                                        width: 40,
                                        height: 100,
                                      ),
                                    ),
                                  );
                                  if (snapshot.hasData) {
                                    child = SizedBox(
                                        width: 40,
                                        height: 100,
                                        child: snapshot.data!);
                                  }
                                  return child;
                                },
                              ),
                              title: (title.isNotEmpty
                                  ? Text("$title ($year)",
                                      style: Styles.fonts.commentName)
                                  : Text(name,
                                      style: Styles.fonts.commentName)),
                              subtitle: (title.isNotEmpty
                                  ? FutureBuilder(
                                      future: PersonsAPI().getPeople(actors),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<Person>>
                                              snapshot) {
                                        var people = [];
                                        if (snapshot.hasData) {
                                          for (var person in snapshot.data!) {
                                            people.add(person.name);
                                          }
                                        }
                                        return Text(people.join(', '),
                                            style: Styles.fonts.comment);
                                      },
                                    )
                                  : null),
                              trailing: Text(_checkType(item),
                                  style: Styles.fonts.comment),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onItemSelected: (dynamic item) {
                  setState(() {
                    // print(item.runtimeType);
                    if (item.runtimeType == Movie) {
                      Movie selected = item as Movie;
                      for (var movie in movies) {
                        if (movie.title == selected.title) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieInfoScreen(movie),
                              ));
                          return;
                        }
                      }
                    }
                    if (item.runtimeType == TvShow) {
                      TvShow selected = item as TvShow;
                      for (var tvShow in tvShows) {
                        if (tvShow.title == selected.title) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TvShowInfoScreen(tvShow),
                              ));
                          return;
                        }
                      }
                    }

                    if (item.runtimeType == Person) {
                      Person selected = item as Person;
                      for (var person in people) {
                        if (person.name == selected.name) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PersonInfoScreen(artist: person),
                              ));
                          return;
                        }
                      }
                    }
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
      child: WillPopScope(
        onWillPop: () async {
          if (Navigator.of(context).userGestureInProgress)
            return false;
          else
            return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
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
                    Container(key: dataKey),
                    searchBar,
                    _buildTextLabel(
                        "Today's Recommendation", Styles.fonts.title),
                    recommendationSection,
                    _buildTextLabel("New Releases", Styles.fonts.title),
                    newReleasesSection,
                    _buildTextLabel("Trending Now", Styles.fonts.title),
                    trendingNowSection,
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

  Future<List<Object>> combineMoviesTvShows() async {
    return [...await moviesFuture, ...await tvShowsFuture];
  }
}
