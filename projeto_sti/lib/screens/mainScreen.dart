import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/bottomAppBar.dart';
import 'package:projeto_sti/components/poster.dart';
import 'package:projeto_sti/screens/favouritesScreen.dart';
import 'package:projeto_sti/screens/genresScreen.dart';
import 'package:projeto_sti/screens/profileScreen.dart';
import 'package:projeto_sti/screens/topImdbScreen.dart';
import 'package:projeto_sti/styles/style.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int selectedCategory = 0;
  late List<String> sections;
  String usersName = "Susan";
  late final ScrollController _controller;
  bool visibleAppBar = false;

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
    var topMovies = Padding(
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
            return Poster(type: 0);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              width: 20.0,
            );
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

    // var topTvShows = Transform.rotate(
    //   angle: -pi / 2,
    //   child: SizedBox(
    //     height: 300,
    //     width: double.infinity,
    //     child: ListWheelScrollView(
    //       diameterRatio: 2.5,
    //       squeeze: 1.4,
    //       physics: const BouncingScrollPhysics(),
    //       itemExtent: 230,
    //       children: List.generate(
    //         10,
    //         (index) => Transform.rotate(
    //           angle: pi / 2,
    //           child: Poster(type: index % 2),
    //         ),
    //       ),
    //     ),
    //   ),
    // );

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
                backgroundImage: const AssetImage(
                    "packages/projeto_sti/assets/images/profile_pic.jpg"),
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
