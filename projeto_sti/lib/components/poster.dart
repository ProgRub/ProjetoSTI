import 'package:flutter/material.dart';

class Poster extends StatelessWidget {
  const Poster({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("TAP POSTER");
      },
      child: Container(
        width: 165,
        height: 230,
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
