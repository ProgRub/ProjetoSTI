import 'package:flutter/material.dart';
import 'package:projeto_sti/screens/byGenreScreen.dart';
import 'package:projeto_sti/styles/style.dart';

import '../models/genre.dart';

class GenreOval extends StatelessWidget {
  final Genre genre;

  const GenreOval({Key? key, required this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 100,
      height: 30,
      decoration: BoxDecoration(
          color: Styles.colors.genre,
          border: Border.all(
            width: 2.0,
            color: genre.color,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ByGenreScreen(genre: genre),
                ));
          },
          child: Text(genre.name,
              style: genre.name == "Documentary"
                  ? Styles.fonts.edit
                  : Styles.fonts.genre)),
    );
  }
}
