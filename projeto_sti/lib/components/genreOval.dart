import 'dart:math';

import 'package:flutter/material.dart';
import 'package:projeto_sti/styles/style.dart';

class GenreOval extends StatelessWidget {
  final String text;

  const GenreOval({
    required this.text,
    Key? key,
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
            color: _randomColor(),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Text(text, style: Styles.fonts.genre),
    );
  }

  Color _randomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }
}
