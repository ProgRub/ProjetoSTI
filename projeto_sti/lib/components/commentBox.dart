import 'package:flutter/material.dart';
import '../styles/style.dart';

class CommentBox extends StatelessWidget {
  final String rate, comment, date, userName, userImage;

  const CommentBox(
      {required this.rate,
      required this.comment,
      required this.date,
      required this.userName,
      required this.userImage,
      Key? key})
      : super(key: key);

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
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    height: 40.0,
                    alignment: Alignment.center,
                    child: Image.asset(
                      "packages/projeto_sti/assets/images/popcorn.png",
                      fit: BoxFit.contain,
                      width: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      rate,
                      style: TextStyle(
                        color: Styles.colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                child: Text(comment, style: Styles.fonts.comment),
              ),
            ])),
      ),
    );
  }
}
