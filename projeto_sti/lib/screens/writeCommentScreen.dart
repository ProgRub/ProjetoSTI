import 'package:flutter/material.dart';
import 'package:projeto_sti/components/bottomAppBar.dart';
import 'package:projeto_sti/api/users.dart';
import 'package:projeto_sti/styles/style.dart';
import 'package:projeto_sti/api/comments.dart';
import 'package:projeto_sti/screens/tvShowInfoScreen.dart';
import 'package:skeletons/skeletons.dart';
import 'movieInfoScreen.dart';
import 'package:jiffy/jiffy.dart';

class WriteCommentScreen extends StatefulWidget {
  late var movieOrTvShow;
  late bool isMovie;
  WriteCommentScreen(this.movieOrTvShow, this.isMovie, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _WriteCommentState(movieOrTvShow, isMovie);
}

class _WriteCommentState extends State<WriteCommentScreen> {

  late var movieOrTvShow;

  late bool isMovie;
  _WriteCommentState(this.movieOrTvShow, this.isMovie);
  double rating = 0.0;
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
          resizeToAvoidBottomInset: false,
          backgroundColor: Styles.colors.background,
          bottomNavigationBar: const AppBarBottom(currentIndex: 3),
          body: Column(
              children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 30, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 25,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),

                        getWidget(),

                        SizedBox(
                            width: 90,
                            height: 130,
                            child: FutureBuilder(
                              future: movieOrTvShow.getPoster(),
                              builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
                                Widget child;
                                child = const SkeletonItem(
                                  child: SkeletonAvatar(
                                    style: SkeletonAvatarStyle(
                                      width: 90,
                                    ),
                                  ),
                                );
                                if (snapshot.hasData) {
                                  child = snapshot.data!;
                                }
                                return child;
                              },
                            )
                        )
                      ],
                    ),
                  ),

                    Slider(
                      value: rating,
                      onChanged: (newRating) {
                        setState(() {
                          rating = newRating;
                          movedBar = true;
                        });
                      },
                      divisions: 9,
                      min: 0,
                      max: 9,

                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 24, 50),
                        child: Container(
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
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '(Optional) Tell us what you think...',
                              hintStyle: TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF57636C),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              filled: true,
                              contentPadding:
                              EdgeInsetsDirectional.fromSTEB(24, 24, 20, 16),
                            ),
                          ),
                        ),
                      ),
                    ),

                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
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
          )
      )
    );
  }

  var beforeRate = Column(
    children: const [
      Text('', style: TextStyle(color: Colors.white, fontSize: 26)),
      Text('Select a rating', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
      Text('from 1 to 10', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
    ],
  );

  Widget getWidget(){
    if(movedBar){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  height: 70.0,
                  alignment: Alignment.center,
                  child: Image.asset(
                    "packages/projeto_sti/assets/images/popcorn.png",
                    fit: BoxFit.contain,
                    width: 45,
                  ),
                ),

                Text((rating+1).toString(),
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight. bold,
                    fontSize: 50,
                  ),
                )
              ]
          ),

          Row(
              mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
                Text(getRatingName((rating+1).toString()),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),)
              ]
          )
        ],
      );
    }
    else{
      return beforeRate;
    }
  }

  String getRatingName(String rating){
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

  void post(){
    if(movedBar){
      DateTime currentTime = DateTime.now();
      String date = Jiffy(currentTime).format('MMM do yyyy');

      CommentAPI().addComment(commentController.text, movieOrTvShow.id, UserAPI().loggedInUser!.authId, date, (rating+1).toString());

      if(isMovie){
        Navigator.push(context, MaterialPageRoute(builder: (context) => MovieInfoScreen(movieOrTvShow),));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => TvShowInfoScreen(movieOrTvShow),));
      }
    }
  }
}

