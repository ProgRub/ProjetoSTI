import 'package:flutter/material.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/bottomAppBar.dart';
import 'package:projeto_sti/screens/byGenreScreen.dart';
import 'package:projeto_sti/styles/style.dart';

class GenresScreen extends StatefulWidget {
  const GenresScreen({Key? key}) : super(key: key);

  @override
  State<GenresScreen> createState() => _GenresState();
}

class _GenresState extends State<GenresScreen> {
  List<String> genres = [
    "Action",
    "Comedy",
    "Sci-Fi",
    "Horror",
    "Romance",
    "Thriller",
    "Drama",
    "Mystery",
    "Crime",
    "Animation",
    "Adventure",
    "Fantasy",
  ];

  @override
  initState() {
    genres.sort((a, b) => a.compareTo(b)); //ordena alfabeticamente
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var genresTitle = Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 30.0, bottom: 20.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Genres",
          style: Styles.fonts.title,
        ),
      ),
    );

    var genresGrid = Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: genres.length,
        itemBuilder: (BuildContext ctx, index) {
          return _buildGenreButton(index);
        },
      ),
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Styles.colors.background,
        bottomNavigationBar: const AppBarBottom(currentIndex: 3),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                child: AppLogo(),
                alignment: Alignment.topLeft,
              ),
              genresTitle,
              genresGrid,
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _buildGenreButton(int index) {
    return GestureDetector(
      onTap: () {
        print("GENRE CLICKED - " + genres[index]);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ByGenreScreen(genre: genres[index]),
            ));
      },
      child: Container(
        alignment: Alignment.center,
        child: Container(
          child: Center(
            child: Text(genres[index], style: Styles.fonts.genreButton),
          ),
          decoration: BoxDecoration(
            color: Styles.colors.darker,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          image: DecorationImage(
            image: AssetImage("packages/projeto_sti/assets/images/xmen.jpg"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
