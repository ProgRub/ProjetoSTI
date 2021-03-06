import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:projeto_sti/api/genres.dart';
import 'package:projeto_sti/api/internetConnection.dart';
import 'package:projeto_sti/api/movies.dart';
import 'package:projeto_sti/api/tvShows.dart';
import 'package:projeto_sti/api/users.dart';
import 'package:projeto_sti/api/comments.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/bottomAppBar.dart';
import 'package:projeto_sti/components/genreOval.dart';
import 'package:projeto_sti/components/commentBox.dart';
import 'package:projeto_sti/components/popupMessage.dart';
import 'package:projeto_sti/screens/personInfoScreen.dart';
import 'package:projeto_sti/screens/tvShowInfoScreen.dart';
import 'package:projeto_sti/screens/writeCommentScreen.dart';
import 'package:projeto_sti/styles/style.dart';
import 'package:projeto_sti/models/movie.dart';

import 'package:like_button/like_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletons/skeletons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'dart:developer' as developer;
import '../api/persons.dart';
import '../models/genre.dart';
import '../models/person.dart';
import '../models/comment.dart';
import '../models/tvShow.dart';

class MovieInfoScreen extends StatefulWidget {
  late Movie movie;
  MovieInfoScreen(this.movie, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MovieInfoState(movie);
}

class _MovieInfoState extends State<MovieInfoScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  late YoutubePlayerController _videoController;
  bool playingTrailer = false;
  late String trailerUrl;

  late bool watched;
  late Movie movie;

  late bool favourited;

  late Future<List<String>> futurePhotos;
  late List<String> moviePhotos = [];

  late bool clickedImage;
  late Image clickedPhoto;

  late List<String> movieVideos;

  _MovieInfoState(this.movie);

  late Future<List<Comment>> comFuture;
  List<Comment> comments = [];
  List<String> user = [];
  late String usersRating = "-";
  late double commentSectionSize = 140;

  @override
  void initState() {
    clickedImage = false;
    MoviesAPI().getMoviesLikeMovie(movie);

    movieVideos = movie.videos;
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
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    movie.getPhotos().then((result) {
      moviePhotos = result;
      setState(() {});
    });
  }

  @override
  void deactivate() {
    _videoController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    if (!hasInternet(context, _connectionStatus)) return isLiked;

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
    if (!hasInternet(context, _connectionStatus)) return;

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
                onPressed: () async {
                  if (!hasInternet(context, _connectionStatus)) return;
                  if (defaultTargetPlatform == TargetPlatform.iOS ||
                      defaultTargetPlatform == TargetPlatform.android) {
                    setState(() {
                      _videoController.seekTo(Duration.zero);
                      playingTrailer = true;
                      _videoController.play();
                    });
                  } else {
                    if (!await launchUrl(Uri.parse(
                        'https://www.youtube.com/watch?v=' + movie.trailer))) {
                      if (!hasInternet(context, _connectionStatus)) return;
                    }
                  }
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
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: GestureDetector(
                  onTap: () {
                    Share.share(
                        "You're going to love this movie! Read more about " +
                            movie.title +
                            " on POPCORN!");
                  },
                  child: const Icon(Icons.share_outlined,
                      size: 40.0, color: Colors.white)),
            ),
            Container(
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                color: Styles.colors.darker,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(children: [
                Tooltip(
                  height: 40,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black),
                  message: "IMDb's rating",
                  triggerMode: TooltipTriggerMode.tap,
                  child: Row(
                    children: [
                      Text(
                        movie.rating.toString(),
                        style: Styles.fonts.rating,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      const Icon(Icons.star, size: 22.0, color: Colors.yellow),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Tooltip(
                  height: 40,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black),
                  message: "User's rating",
                  triggerMode: TooltipTriggerMode.tap,
                  child: Row(
                    children: [
                      Text(
                        "|  " + usersRating,
                        style: Styles.fonts.rating,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Image.asset(
                        "packages/projeto_sti/assets/images/popcorn.png",
                        fit: BoxFit.contain,
                        width: 16,
                      )
                    ],
                  ),
                ),
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
          itemCount: movieVideos.length,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: [
                Container(
                  width: 220,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Styles.colors.purple,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    image: DecorationImage(
                      image: Image.network('https://img.youtube.com/vi/' +
                              movieVideos[index] +
                              '/0.jpg')
                          .image,
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
                      onPressed: () async {
                        if (!await launchUrl(Uri.parse(
                            'https://www.youtube.com/watch?v=' +
                                movieVideos[index]))) {
                          if (!hasInternet(context, _connectionStatus)) return;
                        }
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

    var photosSection = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 20.0,
      ),
      child: SizedBox(
        height: 140,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: moviePhotos.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  clickedImage = true;
                  clickedPhoto = Image.network(moviePhotos[index]);
                });
              },
              child: Container(
                width: 220,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Styles.colors.lightBlue,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  image: DecorationImage(
                    image: Image.network(moviePhotos[index]).image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 20.0);
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
          itemCount: movie.cast.length,
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder(
                future: PersonsAPI().getPersonByID(movie.cast[index]),
                builder:
                    (BuildContext context, AsyncSnapshot<Person> snapshot) {
                  if (!snapshot.hasData) {
                    return const SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                          shape: BoxShape.circle, width: 100, height: 100),
                    );
                  }
                  var actor = snapshot.data!;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PersonInfoScreen(artist: actor),
                          ));
                    },
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            FutureBuilder(
                                future: snapshot.data!.getPhoto(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<Image> snapshot) {
                                  if (!snapshot.hasData) {
                                    return const SkeletonAvatar(
                                      style: SkeletonAvatarStyle(
                                          shape: BoxShape.circle,
                                          width: 100,
                                          height: 100),
                                    );
                                  }
                                  return CircleAvatar(
                                    radius: 52.0,
                                    backgroundColor: Styles.colors.button,
                                    child: CircleAvatar(
                                      radius: 50.0,
                                      backgroundImage: snapshot.data!.image,
                                    ),
                                  );
                                }),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 13.0),
                          child: Text(actor.name,
                              style: Styles.fonts.plot,
                              textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  );
                });
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
      padding: const EdgeInsets.only(
        top: 30.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: movie.directors.length,
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder(
                  future: PersonsAPI().getPersonByID(movie.directors[index]),
                  builder:
                      (BuildContext context, AsyncSnapshot<Person> snapshot) {
                    if (!snapshot.hasData) {
                      return const SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                            shape: BoxShape.circle, width: 100, height: 100),
                      );
                    }
                    var director = snapshot.data!;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PersonInfoScreen(artist: director),
                            ));
                      },
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              FutureBuilder(
                                  future: snapshot.data!.getPhoto(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<Image> snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SkeletonAvatar(
                                        style: SkeletonAvatarStyle(
                                            shape: BoxShape.circle,
                                            width: 100,
                                            height: 100),
                                      );
                                    }
                                    return CircleAvatar(
                                      radius: 52.0,
                                      backgroundColor: Styles.colors.button,
                                      child: CircleAvatar(
                                        radius: 50.0,
                                        backgroundImage: snapshot.data!.image,
                                      ),
                                    );
                                  }),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 13.0),
                            child: Text(director.name,
                                style: Styles.fonts.plot,
                                textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    );
                  });
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                width: 20.0,
              );
            },
          ),
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
              height: commentSectionSize,
              child: FutureBuilder(
                future: CommentAPI().getComments(movie.id),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Comment>> snapshot) {
                  Widget child;
                  child = Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No Comments!", style: Styles.fonts.label),
                          const SizedBox(height: 8.0),
                          Text("Be the first person to",
                              style: Styles.fonts.plot),
                          Text("comment about this movie!",
                              style: Styles.fonts.plot)
                        ],
                      ),
                    ),
                  );
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    comments = snapshot.data!;
                    comments.sort((a, b) {
                      var adate = Jiffy(a.date, 'MMM do yyyy').dateTime;
                      var bdate = Jiffy(b.date, 'MMM do yyyy').dateTime;
                      return -adate.compareTo(bdate);
                    });
                    comments.length > 1
                        ? commentSectionSize = 250
                        : commentSectionSize = 140;
                    if (comments.isNotEmpty) {
                      int sumOfRatings = 0;
                      child = ListView.separated(
                        itemCount: comments.length,
                        itemBuilder: (BuildContext context, int index) {
                          sumOfRatings += int.parse(comments[index].rate);
                          return FutureBuilder(
                            future:
                                UserAPI().getUserById(comments[index].userId),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<String>> snapshot) {
                              String userName = "...";
                              String userImage =
                                  'https://images.unsplash.com/photo-1611590027211-b954fd027b51?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDd8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60';
                              if (snapshot.hasData) {
                                user = snapshot.data!;
                                userName = user[0];
                                userImage = user[1];

                                double num = double.parse(
                                    (sumOfRatings / comments.length)
                                        .toStringAsFixed(1));
                                usersRating = num.toString();

                                child = comments[index].userId ==
                                        UserAPI().loggedInUser!.authId
                                    ? CommentBox(
                                        comments[index].rate,
                                        comments[index].comment,
                                        comments[index].date,
                                        userName,
                                        userImage,
                                        comments[index].id)
                                    : CommentBox(
                                        comments[index].rate,
                                        comments[index].comment,
                                        comments[index].date,
                                        userName,
                                        userImage,
                                        "");

                                return comments[index].userId ==
                                        UserAPI().loggedInUser!.authId
                                    ? Dismissible(
                                        key: Key(index.toString()),
                                        direction: DismissDirection.endToStart,
                                        confirmDismiss:
                                            (DismissDirection direction) async {
                                          return await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return deleteCommentAlert(
                                                  context);
                                            },
                                          );
                                        },
                                        onDismissed: (direction) async {
                                          await CommentAPI().deleteUserComment(
                                              comments[index].id);
                                          setState(() {});
                                        },
                                        background:
                                            Container(color: Colors.white),
                                        secondaryBackground: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          padding: const EdgeInsets.only(
                                              right: 20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Icon(
                                                Icons.delete,
                                                color: Styles.colors.background,
                                              )
                                            ],
                                          ),
                                        ),
                                        child: child,
                                      )
                                    : child;
                              } else {
                                return const SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                    width: 150,
                                    height: 110,
                                  ),
                                );
                              }
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 20.0,
                          );
                        },
                      );
                    }
                  }
                  return child;
                },
              )),
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WriteCommentScreen(movie, true),
                      ));
                },
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
        child: FutureBuilder(
          future: _getSimilarPrograms(),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            Widget child;
            child = skeletonPosterList;
            if (snapshot.hasData) {
              var programs = snapshot.data!;
              child = ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: programs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder(
                      future: programs[index].getPoster(),
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
                                      builder: (context) => programs[index]
                                                  .runtimeType ==
                                              TvShow
                                          ? TvShowInfoScreen(programs[index])
                                          : MovieInfoScreen(programs[index]),
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

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Styles.colors.background,
        bottomNavigationBar: const AppBarBottom(currentIndex: 3),
        body: Stack(
          children: [
            SingleChildScrollView(
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
                  _buildTitle("Comments and Reviews"),
                  commentsSection,
                  _buildTitle("More like " + movie.title),
                  moreLikeThisSection,
                ],
              ),
            ),
            clickedImage
                ? SizedBox.expand(
                    child: Container(
                      color: Styles.colors.backgroundDarker,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10.0, top: 15.0, bottom: 15.0),
                                  child: Container(
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
                                          clickedImage = false;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                          Image(
                            fit: BoxFit.fitWidth,
                            image: clickedPhoto.image,
                          ),
                          const SizedBox(height: 15.0)
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
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

  Future<List<dynamic>> _getSimilarPrograms() async {
    var likeMovies = await MoviesAPI().getMoviesLikeMovie(movie);
    var likeShows = await TVShowsAPI().getTvShowsLikeMovie(movie);
    return [...likeMovies, ...likeShows];
  }
}
