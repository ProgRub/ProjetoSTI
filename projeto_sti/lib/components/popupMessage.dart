import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_sti/api/comments.dart';
import 'package:projeto_sti/styles/style.dart';

class PopupMessage extends StatelessWidget {
  final String type;
  final String message;
  final bool cancel;
  Null Function()? function;
  late String? id;

  PopupMessage({
    required this.type,
    required this.message,
    required this.cancel,
    this.function,
    this.id,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0))),
      contentPadding: const EdgeInsets.all(20.0),
      backgroundColor: Styles.colors.background,
      title: type == "error"
          ? const Icon(Icons.error_outline, size: 50.0, color: Colors.red)
          : const Icon(Icons.check_circle, size: 50.0, color: Colors.green),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
            child: Center(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          (cancel || function != null)
              ? Column(
                  children: [
                    const SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        cancel
                            ? TextButton(
                                child: const Text("Cancel"),
                                style: TextButton.styleFrom(
                                  primary: Styles.colors.errorText,
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () =>
                                    Navigator.of(context, rootNavigator: true)
                                        .pop('dialog'),
                              )
                            : Container(),
                        function != null
                            ? TextButton(
                                child: const Text("OK"),
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: function,
                              )
                            : Container(),
                      ],
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Color popupColor() {
    switch (type) {
      case "error":
        return Styles.colors.errorText;
      case "success":
        return Styles.colors.successText;
      default:
        return Colors.white;
    }
  }
}

showPopupMessageWithFunction(BuildContext context, String type, String message,
    bool cancel, Null Function() functionToCall) {
  // late Timer _timer;
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext builderContext) {
        // _timer = Timer(const Duration(seconds: 2), () {
        //   Navigator.of(context).pop();
        // });
        var popup = PopupMessage(
            type: type,
            message: message,
            cancel: cancel,
            function: functionToCall);
        Null Function() f = () {
          Navigator.of(context, rootNavigator: true).pop(popup);
          functionToCall();
        };
        popup.function = f;
        return popup;
      }).then((val) {
    // if (_timer.isActive) {
    //   _timer.cancel();
    // }
  });
}

AlertDialog deleteCommentAlert(BuildContext context) {
  return AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0))),
    contentPadding: const EdgeInsets.all(20.0),
    backgroundColor: Colors.black,
    title: const Icon(Icons.error_outline, size: 50.0, color: Colors.red),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40,
          child: Center(
            child: Text(
              "Are you sure you want to delete this comment?",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text("Cancel"),
                  style: TextButton.styleFrom(
                    primary: Styles.colors.errorText,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: const Text("Yes"),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

AlertDialog deleteCommentAlertWithFunction(BuildContext context, id) {
  return AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0))),
    contentPadding: const EdgeInsets.all(20.0),
    backgroundColor: Colors.black,
    title: const Icon(Icons.error_outline, size: 50.0, color: Colors.red),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40,
          child: Center(
            child: Text(
              "Are you sure you want to delete this comment?",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text("Cancel"),
                  style: TextButton.styleFrom(
                    primary: Styles.colors.errorText,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: const Text("Yes"),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () async {
                    await CommentAPI().deleteUserComment(id);
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

showPopupMessage(
    BuildContext context, String type, String message, bool cancel) {
  // late Timer _timer;
  showDialog(
      barrierDismissible: cancel ? false : true,
      context: context,
      barrierColor: Styles.colors.darker,
      builder: (BuildContext builderContext) {
        return PopupMessage(type: type, message: message, cancel: cancel);
      }).then((val) {});
}
