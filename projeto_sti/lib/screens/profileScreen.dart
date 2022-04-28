import 'package:flutter/material.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/bottomAppBar.dart';
import 'package:projeto_sti/components/genreOval.dart';
import 'package:projeto_sti/components/popupMessage.dart';
import 'package:projeto_sti/components/poster.dart';
import 'package:projeto_sti/components/quarterCircle.dart';
import 'package:projeto_sti/screens/editProfileScreen.dart';
import 'package:projeto_sti/styles/style.dart';

import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  late int selectedCategory = 0;
  late List<String> sections;
  late List<String> favouriteGenres;
  late List<GenreOval> genres;

  @override
  initState() {
    sections = ["All", "Movies", "Tv Shows"];
    favouriteGenres = ["Action", "Horror", "Drama"];
    genres = _favouriteGenres();
    super.initState();
  }

  List<GenreOval> _favouriteGenres() {
    List<GenreOval> list = <GenreOval>[];
    for (var title in favouriteGenres) {
      list.add(GenreOval(text: title, color: _randomColor()));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
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
      child: Center(
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
                onTap: () =>
                    showPopupMessage(context, "error", "Logout"), //PARA TESTAR
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
                            radius: 40.0,
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(
                                  "packages/projeto_sti/assets/images/profile_pic.jpg"), //TESTING
                              radius: 38.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Text("Susan Ceal", style: Styles.fonts.label),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection("5", "Favourites"),
                      _buildInfoSection("12", "Watched\n Movies"),
                      _buildInfoSection("4", "Watched \nTv Shows"),
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
                  tabs,
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 4,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                    itemCount: 3,
                    itemBuilder: (BuildContext ctx, index) {
                      return Poster(type: 0);
                    },
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
