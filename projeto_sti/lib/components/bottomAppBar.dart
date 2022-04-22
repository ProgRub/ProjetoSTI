import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_sti/screens/favouritesScreen.dart';
import 'package:projeto_sti/screens/genresScreen.dart';
import 'package:projeto_sti/screens/mainScreen.dart';
import 'package:projeto_sti/screens/profileScreen.dart';
import 'package:projeto_sti/screens/topImdbScreen.dart';
import 'package:projeto_sti/styles/style.dart';

class AppBarBottom extends StatelessWidget {
  final int currentIndex;

  const AppBarBottom({required this.currentIndex, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 3.0, color: Styles.colors.lightBlue),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Styles.colors.purple,
        unselectedItemColor: Styles.colors.grey,
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  _navigateTo(context, const MainScreen());
                },
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  _navigateTo(context, const FavouritesScreen());
                },
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: const FaIcon(FontAwesomeIcons.trophy, size: 20.0),
                onPressed: () {
                  _navigateTo(context, const TopImdbScreen());
                },
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.grid_view),
                onPressed: () {
                  _navigateTo(context, const GenresScreen());
                },
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  _navigateTo(context, const ProfileScreen());
                },
              ),
              label: ""),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget state) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => state,
        ));
  }
}
