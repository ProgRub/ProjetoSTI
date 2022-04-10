import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_sti/api/genres.dart';
import 'package:bubble_chart/bubble_chart.dart';
import 'package:projeto_sti/styles/style.dart';
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
    for (var element in GenresAPI.genres) {
      var node = BubbleNode.leaf(
        value: 5,
        options: BubbleOptions(
          child: Text(element),
          color: Colors.white,
          border: Border.all(color: Styles.colors.purple),
        ),
      );
      node.options?.onTap = () => setState(() {
            clickedGenre(node);
          });
      childrenNodes.add(node);
    }
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
          style: GoogleFonts.lato(
            fontSize: 12,
            color: alreadySelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        color: alreadySelected ? Colors.white : Styles.colors.purple,
        border: Border.all(
            color: alreadySelected ? Styles.colors.purple : Colors.white,
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
    for (var element in GenresAPI.genres) {
      var node = BubbleNode.leaf(
        value: 5,
        options: BubbleOptions(
          child: Text(
            element,
            style: GoogleFonts.lato(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          color: Colors.white,
          border: Border.all(
            color: Styles.colors.purple,
            width: 2.0,
          ),
        ),
      );
      node.options?.onTap = () => setState(() {
            clickedGenre(node);
          });
      childrenNodes.add(node);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Styles.colors.background,
        body: Stack(
          children: [
            const AppLogo(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 70),
                  child: Text(
                    "Choose three or more of your favourite genres:",
                    textAlign: TextAlign.center,
                    style: Styles.fonts.title,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 0),
                  child: SizedBox(
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
                      duration: const Duration(milliseconds: 500),
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
                      primary: Styles.colors.button,
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
                      style: Styles.fonts.button,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 60, left: 60, bottom: 10),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          clearSelectedGenres();
                        });
                      },
                      child: Text(
                        "Reset",
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
