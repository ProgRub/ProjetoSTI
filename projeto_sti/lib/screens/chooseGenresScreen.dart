import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_sti/api/genres.dart';
import 'package:bubble_chart/bubble_chart.dart';
import 'package:projeto_sti/api/internetConnection.dart';
import 'package:projeto_sti/api/users.dart';
import 'package:projeto_sti/components/popupMessage.dart';
import 'package:projeto_sti/screens/mainScreen.dart';
import 'package:projeto_sti/styles/style.dart';
import '../components/appLogo.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import '../models/genre.dart';

class ChooseGenresScreen extends StatefulWidget {
  const ChooseGenresScreen({Key? key}) : super(key: key);

  @override
  State<ChooseGenresScreen> createState() => _ChooseGenresState();
}

class _ChooseGenresState extends State<ChooseGenresScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  List<BubbleNode> childrenNodes = [];
  List<String> selectedGenres = [];
  final Future<List<Genre>> genresFuture = GenresAPI().getAllGenres();
  List<Genre> genres = [];
  late bool changingPreferences;
  List<String> alreadySelected = UserAPI().getGenrePreferences();

  @override
  void initState() {
    changingPreferences = alreadySelected.isNotEmpty;
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
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

  void clickedGenre(BubbleNode node) {
    var genre = (node.options?.child as Text).data.toString();
    var alreadySelected = selectedGenres.contains(genre);
    var options = BubbleOptions(
        onTap: () => setState(() {
              clickedGenre(node);
            }),
        child: Text(
          genre,
          style: GoogleFonts.lato(
            fontSize:
                genre == "Documentary" ? 9 : (genre == "Adventure" ? 11 : 12),
            color: alreadySelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        color: alreadySelected ? Colors.white : Styles.colors.purple,
        border: Border.all(
            color: alreadySelected ? Styles.colors.purple : Colors.white,
            width: 2));
    if (alreadySelected) {
      selectedGenres.remove(genre);
    } else {
      selectedGenres.add(genre);
    }
    node.options = options;
  }

  void clearSelectedGenres() {
    selectedGenres.clear();
    childrenNodes.clear();
    for (var element in genres) {
      var node = BubbleNode.leaf(
        value: 5,
        options: BubbleOptions(
          child: Text(
            element.name,
            style: GoogleFonts.lato(
              fontSize: element.name == "Documentary"
                  ? 9
                  : (element.name == "Adventure" ? 11 : 12),
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          color: Colors.white,
          border: Border.all(
            color: Styles.colors.purple,
            width: 2.0,
          ),
        ),
      );
      node.options?.onTap = () => setState(() {
            clickedGenre(node);
          });
      childrenNodes.add(node);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Styles.colors.background,
        body: Stack(
          children: [
            const AppLogo(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 70),
                  child: Text(
                    "Choose three or more of your favourite genres:",
                    textAlign: TextAlign.center,
                    style: Styles.fonts.title,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 0),
                    child: FutureBuilder(
                        future: genresFuture,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Genre>> snapshot) {
                          Widget child;
                          child = SizedBox(
                            width: 60,
                            height: (MediaQuery.of(context).size.height >= 740)
                                ? 500
                                : 350,
                            child: Center(
                              child: SizedBox(
                                width: 90,
                                height: 90,
                                child: Image.asset(
                                    "packages/projeto_sti/assets/images/film-popcorn.gif",
                                    width: 90,
                                    height: 90),
                              ),
                            ),
                          );

                          if (snapshot.hasData && genres.isEmpty) {
                            genres = snapshot.data!;
                            for (var element in genres) {
                              var node = BubbleNode.leaf(
                                value: 5,
                                options: BubbleOptions(
                                  child: Text(
                                    element.name,
                                    style: GoogleFonts.lato(
                                      fontSize: element.name == "Documentary"
                                          ? 9
                                          : (element.name == "Adventure"
                                              ? 11
                                              : 12),
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Styles.colors.purple, width: 2.0),
                                ),
                              );
                              node.options?.onTap = () => setState(() {
                                    clickedGenre(node);
                                  });

                              if (alreadySelected.contains(element.name)) {
                                clickedGenre(node);
                              }

                              childrenNodes.add(node);
                            }
                          }
                          if (genres.isNotEmpty) {
                            child = SizedBox(
                                width: double.infinity,
                                height:
                                    (MediaQuery.of(context).size.height >= 740)
                                        ? 500
                                        : 350,
                                child: BubbleChartLayout(
                                  duration: const Duration(milliseconds: 500),
                                  padding: 0,
                                  children: [
                                    BubbleNode.node(
                                        padding: 3,
                                        children: childrenNodes,
                                        options: BubbleOptions(
                                            color: Colors.transparent))
                                  ],
                                ));
                          }
                          return child;
                        })),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Styles.colors.button,
                    minimumSize: const Size(200, 40),
                  ),
                  onPressed: () {
                    if (selectedGenres.length < 3) {
                      showPopupMessage(context, "error",
                          "You have to choose at least 3 genres!", false);
                      return;
                    } else {
                      if (!changingPreferences) {
                        if (hasInternet(context, _connectionStatus)) return;

                        UserAPI().setUserPreferences(selectedGenres);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const MainScreen()));
                      } else {
                        Navigator.of(context).pop(selectedGenres);
                      }
                    }
                  },
                  child: Text(
                    changingPreferences ? "Done" : "Let's start!",
                    style: Styles.fonts.button,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 60, left: 60, bottom: 10),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          clearSelectedGenres();
                        });
                      },
                      child: Text(
                        "Reset",
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
