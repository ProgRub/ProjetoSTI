import 'package:flutter/material.dart';
import '../styles/style.dart';

class CommentBox extends StatefulWidget {
  late String rate, comment, date, userName, userImage;
  CommentBox(this.rate, this.comment, this.date, this.userName, this.userImage,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _CommentBoxState(rate, comment, date, userName, userImage);
}

class _CommentBoxState extends State<CommentBox> {
  late String rate, comment, date, userName, userImage;
  _CommentBoxState(
      this.rate, this.comment, this.date, this.userName, this.userImage);

  late String firstHalf;
  late String secondHalf;
  late bool flag = true;

  @override
  void initState() {
    super.initState();

    if (comment.length > 200) {
      firstHalf = comment.substring(0, 200);
      secondHalf = comment.substring(200, comment.length);
    } else {
      firstHalf = comment;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
        child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      userImage,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: Styles.fonts.commentName,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            date,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              color: Color(0xFF57636C),
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: Text(
                      rate + "/10",
                      style: TextStyle(
                        color: Styles.colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    height: 36.0,
                    alignment: Alignment.center,
                    child: Image.asset(
                      "packages/projeto_sti/assets/images/popcorn.png",
                      fit: BoxFit.contain,
                      width: 18,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                child: secondHalf.isEmpty
                    ? Text(comment, style: Styles.fonts.comment)
                    : Column(
                        children: <Widget>[
                          Text(
                              flag
                                  ? (firstHalf + "...")
                                  : (firstHalf + secondHalf),
                              style: Styles.fonts.comment),
                          InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  flag ? "show more" : "show less",
                                  style:
                                      TextStyle(color: Styles.colors.lightBlue),
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                flag = !flag;
                              });
                            },
                          ),
                        ],
                      ),
                //Text(comment, style: Styles.fonts.comment),
              ),
            ])),
      ),
    );
  }
}
