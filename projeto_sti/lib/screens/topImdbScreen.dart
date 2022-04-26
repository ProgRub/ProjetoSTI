import 'package:flutter/material.dart';
import 'package:projeto_sti/components/appLogo.dart';
import 'package:projeto_sti/components/bottomAppBar.dart';
import 'package:projeto_sti/screens/movieInfoScreen.dart';
import 'package:projeto_sti/styles/style.dart';
import 'package:google_fonts/google_fonts.dart';

class TopImdbScreen extends StatefulWidget {
  const TopImdbScreen({Key? key}) : super(key: key);

  @override
  State<TopImdbScreen> createState() => _TopImdbState();
}

class _TopImdbState extends State<TopImdbScreen> {
  late int selectedCategory;
  final List<String> categories = ["Movies", "Tv Shows"];
  String filterValue = "All";
  List<String> filters = [
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
    filters.sort((a, b) => a.compareTo(b)); //ordena alfabeticamente
    filters.insert(0, "All");
    selectedCategory = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var pageTitle = Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 30.0, bottom: 20.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Top iMDB",
          style: Styles.fonts.title,
        ),
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
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: index == selectedCategory
                        ? Styles.colors.purple
                        : Styles.colors.grey)),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: 6,
                width: 90,
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
      padding: const EdgeInsets.only(top: 10.0, left: 30.0),
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

    var filterRow = Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Row(
        children: [
          Text("Filter:", style: Styles.fonts.label),
          const SizedBox(width: 10.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: DropdownButton<String>(
                focusColor: Colors.transparent,
                value: filterValue,
                isDense: true,
                style: Styles.fonts.plot,
                onChanged: (String? newFilter) {
                  setState(() {
                    filterValue = newFilter!;
                  });
                },
                icon: const Icon(Icons.arrow_drop_down,
                    color: Colors.transparent),
                iconSize: 0,
                underline: const SizedBox(),
                items: filters.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );

    var moviesList = Column(
      children: [
        ListView.separated(
          itemCount: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return _buildMovieRow(index + 1, "Joker", "9.6");
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 30.0);
          },
        ),
      ],
    );

    var tvShowsList = Column(
      children: [
        ListView.separated(
          itemCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return _buildMovieRow(index + 1, "Avatar", "9.5");
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 30.0);
          },
        ),
      ],
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Styles.colors.background,
        bottomNavigationBar: const AppBarBottom(currentIndex: 2),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  child: AppLogo(),
                  alignment: Alignment.topLeft,
                ),
                pageTitle,
                tabs,
                filterRow,
                const SizedBox(height: 30.0),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 0),
                  firstChild: moviesList,
                  secondChild: tvShowsList,
                  crossFadeState: selectedCategory == 0
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildMovieRow(int index, String title, String rating) {
    return GestureDetector(
      onTap: () {
        print("TAPPED MOVIE - $title");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MovieInfoScreen(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 80,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      image: AssetImage(
                          "packages/projeto_sti/assets/images/profile.jpg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(width: 40.0),
                Text(
                  "#$index - $title",
                  style: Styles.fonts.label,
                ),
              ],
            ),
            Row(children: [
              Text(rating, style: Styles.fonts.rating),
              const SizedBox(width: 5.0),
              const Icon(
                Icons.star,
                size: 25.0,
                color: Colors.yellow,
              )
            ])
          ],
        ),
      ),
    );
  }
}
