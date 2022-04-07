import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_sti/api/genres.dart';
import 'package:bubble_chart/bubble_chart.dart';
import '../components/appLogo.dart';

class ChooseGenresScreen extends StatefulWidget {
  const ChooseGenresScreen({Key? key}) : super(key: key);

  @override
  State<ChooseGenresScreen> createState() => _ChooseGenresState();
}

class _ChooseGenresState extends State<ChooseGenresScreen> {
  List<BubbleNode> childrenNodes = [];
  List<String> selectedGenres = [];

  @override
  void initState() {
    super.initState();
    GenresAPI.Genres.forEach((element) {
      var node = BubbleNode.leaf(
          value: 5,
          options: BubbleOptions(
              child: Text(element),
              color: Colors.white,
              border: Border.all(
                  color: const Color.fromARGB(255, 187, 134, 252), width: 2)));
      node.options?.onTap = () => setState(() {
            clickedGenre(node);
          });
      childrenNodes.add(node);
    });
  }

  void clickedGenre(BubbleNode node) {
    var genre = (node.options?.child as Text).data.toString();
    var alreadySelected = selectedGenres.contains(genre);
    var options = BubbleOptions(
        onTap: () => setState(() {
              clickedGenre(node);
            }),
        child: Text(
          genre,
          style:
              TextStyle(color: alreadySelected ? Colors.black : Colors.white),
        ),
        color: alreadySelected
            ? Colors.white
            : const Color.fromARGB(255, 187, 134, 252),
        border: Border.all(
            color: alreadySelected
                ? const Color.fromARGB(255, 187, 134, 252)
                : Colors.white,
            width: 2));
    if (alreadySelected) {
      selectedGenres.remove(genre);
    } else {
      selectedGenres.add(genre);
    }
    node.options = options;
  }

  void clearSelectedGenres() {
    selectedGenres.clear();
    childrenNodes.clear();
    GenresAPI.Genres.forEach((element) {
      var node = BubbleNode.leaf(
          value: 5,
          options: BubbleOptions(
              child: Text(element),
              color: Colors.white,
              border: Border.all(
                  color: const Color.fromARGB(255, 187, 134, 252), width: 2)));
      node.options?.onTap = () => setState(() {
            clickedGenre(node);
          });
      childrenNodes.add(node);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 56, 51, 51),
      body: Stack(
        children: [
          const AppLogo(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 60, right: 60, top: 60),
                child: Text(
                  "Choose three or more of your favourite genres:",
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0, top: 0),
                child: Container(
                  // padding:
                  //     const EdgeInsets.only(left: 60, right: 60, bottom: 30),
                  height: MediaQuery.of(context).size.width <
                          MediaQuery.of(context).size.height
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width <
                          MediaQuery.of(context).size.height
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.height,
                  child: BubbleChartLayout(
                    duration: Duration(milliseconds: 500),
                    padding: 0,
                    children: [
                      BubbleNode.node(
                          padding: 3,
                          children: childrenNodes,
                          options: BubbleOptions(color: Colors.transparent))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 0,
                  right: 60,
                  left: 60,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(55, 0, 179, 1),
                    minimumSize: const Size(300, 50),
                  ),
                  onPressed: () {
                    if (selectedGenres.length < 3) {
                      print("NOT ENOUGH");
                      return;
                    }
                  },
                  child: Text(
                    "Let's start!",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 60, left: 60, bottom: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(0, 54, 0, 179),
                      minimumSize: const Size(300, 50),
                    ),
                    onPressed: () {
                      setState(() {
                        clearSelectedGenres();
                      });
                    },
                    child: Text(
                      "Reset",
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
