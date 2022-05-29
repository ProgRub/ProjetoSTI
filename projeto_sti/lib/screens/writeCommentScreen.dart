import 'package:flutter/material.dart';
import 'package:projeto_sti/components/bottomAppBar.dart';
import 'package:projeto_sti/api/users.dart';
import 'package:projeto_sti/components/popupMessage.dart';
import 'package:projeto_sti/styles/style.dart';
import 'package:projeto_sti/api/comments.dart';
import 'package:projeto_sti/screens/tvShowInfoScreen.dart';
import 'package:skeletons/skeletons.dart';
import 'movieInfoScreen.dart';
import 'package:jiffy/jiffy.dart';

class WriteCommentScreen extends StatefulWidget {
  late var movieOrTvShow;
  late bool isMovie;
  WriteCommentScreen(this.movieOrTvShow, this.isMovie, {Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() =>
      _WriteCommentState(movieOrTvShow, isMovie);
}

class _WriteCommentState extends State<WriteCommentScreen> {
  late var movieOrTvShow;

  late bool isMovie;
  _WriteCommentState(this.movieOrTvShow, this.isMovie);
  double rating = 0.0;
  String ratingLabel = "";
  bool movedBar = false;
  late TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Styles.colors.background,
        bottomNavigationBar: const AppBarBottom(currentIndex: 3),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, top: 15.0),
                    child: Container(
                      width: 47,
                      height: 47,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffF4F6FD),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 30, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 75,
                      height: 115,
                      child: FutureBuilder(
                        future: movieOrTvShow.getPoster(),
                        builder: (BuildContext context,
                            AsyncSnapshot<Image> snapshot) {
                          Widget child;
                          child = const SkeletonItem(
                            child: SkeletonAvatar(
                              style: SkeletonAvatarStyle(
                                width: 75,
                              ),
                            ),
                          );
                          if (snapshot.hasData) {
                            child = snapshot.data!;
                          }
                          return child;
                        },
                      ),
                    ),
                    movedBar
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      (rating + 1).toInt().toString() + "/10",
                                      style: TextStyle(
                                        color: Styles.colors.purple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 36,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          13, 0, 0, 0),
                                      height: 60.0,
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        "packages/projeto_sti/assets/images/popcorn.png",
                                        fit: BoxFit.contain,
                                        width: 40,
                                      ),
                                    ),
                                  ]),
                              const SizedBox(height: 15),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      ratingLabel,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                      ),
                                    )
                                  ])
                            ],
                          )
                        : beforeRate
                  ],
                ),
              ),
              SliderTheme(
                data: const SliderThemeData(
                  showValueIndicator: ShowValueIndicator.always,
                  valueIndicatorColor: Colors.black,
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  trackHeight: 5, trackShape: null,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 13),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 25),
                  //rangeTickMarkShape: RoundRangeSliderTickMarkShape(tickMarkRadius: 18.0)
                ),
                child: Slider(
                  value: rating,
                  label: (rating + 1).toInt().toString(),
                  onChanged: (newRating) {
                    setState(() {
                      rating = newRating;
                      ratingLabel = getRatingName((rating + 1).toInt().toString());
                      movedBar = true;
                    });
                  },
                  divisions: 9,
                  min: 0,
                  max: 9,
                  activeColor: Styles.colors.lightBlue,
                  inactiveColor: Styles.colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 30, 24, 30),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: commentController,
                    obscureText: false,
                    maxLines: double.maxFinite.floor(),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Tell us what you think... (Optional)',
                      hintStyle: TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Styles.colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                      filled: true,
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                child: ElevatedButton(
                  child: Text("Post", style: Styles.fonts.button),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    primary: Styles.colors.button,
                    minimumSize: const Size(260, 50),
                  ),
                  onPressed: () {
                    post();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var beforeRate = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: const [
      Text('Select a rating',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
      Text('from 1 to 10',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
    ],
  );

  String getRatingName(String rating) {
    switch (rating) {
      case '1':
        return 'Horrible';
      case '2':
        return 'Terrible';
      case '3':
        return 'Bad';
      case '4':
        return 'Poor';
      case '5':
        return 'Meh';
      case '6':
        return 'Decent';
      case '7':
        return 'Good';
      case '8':
        return 'Great';
      case '9':
        return 'Fantastic';
      default:
        return 'Amazing';
    }
  }

  void post() {
    if (movedBar) {
      DateTime currentTime = DateTime.now();
      String date = Jiffy(currentTime).format('MMM do yyyy');

      CommentAPI().addComment(
          commentController.text,
          movieOrTvShow.id,
          UserAPI().loggedInUser!.authId,
          date,
          (rating + 1).toInt().toString());

      showPopupMessageWithFunction(
          context, "success", "Your comment has been posted!", false, () {
        if (isMovie) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieInfoScreen(movieOrTvShow),
              ));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TvShowInfoScreen(movieOrTvShow),
              ));
        }
      });
    }
  }
}
