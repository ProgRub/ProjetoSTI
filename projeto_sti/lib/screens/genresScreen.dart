import 'package:flutter/material.dart';
import 'package:projeto_sti/api/genres.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/bottomAppBar.dart';
import 'package:projeto_sti/screens/byGenreScreen.dart';
import 'package:projeto_sti/styles/style.dart';

import '../models/genre.dart';

class GenresScreen extends StatefulWidget {
  const GenresScreen({Key? key}) : super(key: key);

  @override
  State<GenresScreen> createState() => _GenresState();
}

class _GenresState extends State<GenresScreen> {
  Future<List<Genre>> genresFuture = GenresAPI().getAllGenres();
  List<Genre> genres = [];

  @override
  initState() {
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

    // var genresGrid = Padding(
    //   padding: const EdgeInsets.all(20.0),
    //   child: GridView.builder(
    //     physics: const NeverScrollableScrollPhysics(),
    //     shrinkWrap: true,
    //     gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
    //         maxCrossAxisExtent: 200,
    //         childAspectRatio: 3 / 2,
    //         crossAxisSpacing: 20,
    //         mainAxisSpacing: 20),
    //     itemCount: genres.length,
    //     itemBuilder: (BuildContext ctx, index) {
    //       return _buildGenreButton(index);
    //     },
    //   ),
    // );
    var genresGrid = FutureBuilder(
        future: genresFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Genre>> snapshot) {
          Widget child;
          child = const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          );
          if (snapshot.hasData) {
            genres = snapshot.data!;
            genres.sort(
                (a, b) => a.name.compareTo(b.name)); //ordena alfabeticamente
            child = Padding(
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
                  return FutureBuilder(
                      future: genres[index].getImage(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Image> snapshot) {
                        Widget child;
                        child = const SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(),
                        );
                        if (snapshot.hasData) {
                          child = _buildGenreButton(index, snapshot.data!);
                        }
                        return child;
                      });
                },
              ),
            );
          }
          return child;
        });

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

  GestureDetector _buildGenreButton(int index, Image image) {
    return GestureDetector(
      onTap: () {
        print("GENRE CLICKED - " + genres[index].name);
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
            child: Text(genres[index].name, style: Styles.fonts.genreButton),
          ),
          decoration: BoxDecoration(
            color: Styles.colors.darker,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          image: DecorationImage(
            image: image.image,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
