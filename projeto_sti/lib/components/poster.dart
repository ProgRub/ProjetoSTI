import 'package:flutter/material.dart';
import 'package:projeto_sti/screens/movieInfoScreen.dart';

class Poster extends StatelessWidget {
  late int type;

  Poster({
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const MovieInfoScreen(),
        //     ));
      },
      child: Container(
        width: 150,
        height: 220,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          image: DecorationImage(
            image: type == 0
                ? const AssetImage(
                    "packages/projeto_sti/assets/images/joker_poster.jpg")
                : const AssetImage(
                    "packages/projeto_sti/assets/images/stranger_poster.jpg"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
