import 'package:flutter/material.dart';
import 'package:projeto_sti/animation/fadeAnimation.dart';
import 'package:projeto_sti/components/inputForm.dart';
import 'package:projeto_sti/components/popupMessage.dart';

class InputScreen extends StatefulWidget {
  final String? text;

  const InputScreen({Key? key, this.text}) : super(key: key);

  @override
  InputState createState() => InputState();
}

class InputState extends State<InputScreen> {
  late String description;

  @override
  void initState() {
    super.initState();

    description = widget.text ?? ''; // for get null or value
  }

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FD),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        backgroundColor: Colors.green,
        onPressed: editName,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            FadeAnimation(
              delay: 0.2,
              child: Container(
                margin: EdgeInsets.only(top: he * 0.05, left: we * 0.73),
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey[300], shape: BoxShape.circle),
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
            ),
            FadeAnimation(
              delay: 0.3,
              child: InputFormWidget(
                description: description,
                onChangedDescription: (description) {
                  setState(() => this.description = description);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future editName() async {
    if (description.isNotEmpty) {
      Navigator.of(context).pop(description);
    } else {
      showPopupMessage(context, "error", "Please, enter your name!");
    }
  }
}
