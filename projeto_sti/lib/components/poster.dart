import 'package:flutter/material.dart';
import 'package:projeto_sti/screens/movieInfoScreen.dart';

class Poster extends StatelessWidget {
  const Poster({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MovieInfoScreen(),
            ));
      },
      child: Container(
        width: 150,
        height: 220,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          image: DecorationImage(
            image: AssetImage("packages/projeto_sti/assets/images/profile.jpg"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
