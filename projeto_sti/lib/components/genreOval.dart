import 'package:flutter/material.dart';
import 'package:projeto_sti/styles/style.dart';

class GenreOval extends StatelessWidget {
  final String text;
  final Color color;

  const GenreOval({
    required this.text,
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 90,
      height: 30,
      decoration: BoxDecoration(
          color: Styles.colors.genre,
          border: Border.all(
            color: color,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Text(text, style: Styles.fonts.genre),
    );
  }
}
