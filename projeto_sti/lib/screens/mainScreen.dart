import 'package:flutter/material.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/poster.dart';
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

  @override
  initState() {
    sections = ["All", "Movies", "Tv Shows"];
    super.initState();
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
            return const Poster();
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
            return const Poster();
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              width: 20.0,
            );
          },
        ),
      ),
    );

    var recommendationSection = Container(
      width: MediaQuery.of(context).size.width - 60,
      height: 160,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        image: DecorationImage(
          image: AssetImage("packages/projeto_sti/assets/images/profile.jpg"),
          fit: BoxFit.fill,
        ),
      ),
    );

    var buttonsSection = Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton(const Icon(Icons.favorite, size: 30.0), "Favourites"),
          _buildButton(
              const FaIcon(FontAwesomeIcons.trophy, size: 25.0), "Top iMDB"),
          _buildButton(const Icon(Icons.grid_view, size: 32.0), "Genres"),
          _buildButton(const Icon(Icons.person, size: 32.0), "Profile"),
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
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(
                    "packages/projeto_sti/assets/images/profile.jpg"),
                radius: 34.0,
              ),
            ),
            CircleAvatar(
              backgroundColor: Styles.colors.darker,
              radius: 34.0,
            ),
          ],
        ),
      ],
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Styles.colors.background,
        body: SingleChildScrollView(
          child: Column(children: [
            const Align(
              child: AppLogo(),
              alignment: Alignment.topLeft,
            ),
            topSection,
            buttonsSection,
            _buildTextLabel("Today's Recommendation", Styles.fonts.title),
            recommendationSection,
            _buildTextLabel("New Releases", Styles.fonts.title),
            topTvShows, //apenas para testar layout
            _buildTextLabel("Trending Now", Styles.fonts.title),
            topTvShows, //apenas para testar layout
            _buildTextLabel("Top Movies", Styles.fonts.title),
            topMovies,
            _buildTextLabel("Top Tv Shows", Styles.fonts.title),
            topTvShows,
          ]),
        ),
      ),
    );
  }

  Column _buildButton(Widget? icon, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: icon,
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            side: BorderSide(color: Styles.colors.purple, width: 2.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            minimumSize: const Size(60.0, 60.0),
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