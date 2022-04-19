import 'package:flutter/material.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/poster.dart';
import 'package:projeto_sti/styles/style.dart';
import 'package:google_fonts/google_fonts.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesState();
}

class _FavouritesState extends State<FavouritesScreen> {
  late int selectedCategory;
  final List<String> categories = ["All", "Movies", "Tv Shows"];

  @override
  initState() {
    selectedCategory = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var genreTitle = Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 30.0, bottom: 20.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Your Favourites",
          style: Styles.fonts.title,
        ),
      ),
    );

    var allGrid = Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: 7,
        itemBuilder: (BuildContext ctx, index) {
          return _buildPoster(index);
        },
      ),
    );

    var moviesGrid = Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: 5,
        itemBuilder: (BuildContext ctx, index) {
          return _buildPoster(index);
        },
      ),
    );

    var tvShowsGrid = Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: 2,
        itemBuilder: (BuildContext ctx, index) {
          return _buildPoster(index);
        },
      ),
    );

    //Method to create a tab
    GestureDetector createTab(index, context) {
      return GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(categories[index],
                style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: index == selectedCategory
                        ? Styles.colors.purple
                        : Styles.colors.grey)),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: 6,
                width: index * 30.0 + 40,
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

    Padding tabs = Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
      child: SizedBox(
        height: 70,
        child: Row(
          children: [
            ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => createTab(index, context),
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 50,
                );
              },
            ),
          ],
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Styles.colors.background,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                child: AppLogo(),
                alignment: Alignment.topLeft,
              ),
              genreTitle,
              tabs,
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                firstChild: allGrid,
                secondChild: selectedCategory == 1 ? moviesGrid : tvShowsGrid,
                crossFadeState: selectedCategory == 0
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _buildPoster(int index) {
    return GestureDetector(
      onTap: () {
        print("POSTER CLICKED");
      },
      child: const Poster(),
    );
  }
}
