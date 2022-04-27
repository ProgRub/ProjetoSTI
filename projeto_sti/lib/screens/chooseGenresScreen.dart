import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_sti/api/genres.dart';
import 'package:bubble_chart/bubble_chart.dart';
import 'package:projeto_sti/components/popupMessage.dart';
import 'package:projeto_sti/screens/mainScreen.dart';
import 'package:projeto_sti/styles/style.dart';
import '../components/appLogo.dart';
import 'dart:io' show Platform;

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
          child: Text(
            element,
            style: GoogleFonts.lato(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          color: Colors.white,
          border: Border.all(color: Styles.colors.purple, width: 2.0),
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
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
    print("RESULT" +
        (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.height)
            .toString());
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Styles.colors.background,
        body: Stack(
          children: [
            const AppLogo(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    width: MediaQuery.of(context).size.width <
                            MediaQuery.of(context).size.height
                        ? MediaQuery.of(context).size.width
                        : MediaQuery.of(context).size.height,
                    height: (Platform.isWindows ||
                            Platform.isMacOS ||
                            Platform.isLinux)
                        ? MediaQuery.of(context).size.height - 250
                        : (MediaQuery.of(context).size.width <
                                MediaQuery.of(context).size.height
                            ? MediaQuery.of(context).size.width
                            : MediaQuery.of(context).size.height),
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
                      minimumSize: const Size(200, 40),
                    ),
                    onPressed: () {
                      if (selectedGenres.length < 3) {
                        showPopupMessage(context, "error",
                            "You have to choose at least 3 genres!");
                        return;
                      } else {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const MainScreen()));
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
