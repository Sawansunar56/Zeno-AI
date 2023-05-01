import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

class AiText extends StatelessWidget {
  const AiText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.3),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Text(
              "There are several ways to make an HTTP request in JavaScript, including using the Xmlhttprequest object, the and using libraries such as Axios or jQuery. Here is an example of making a GET request using the XMLHttpRequest object:Make HTTP request in Javascript",
              style: TextStyle(
                  color: black,
                  fontSize: 14,
                  height: 1.5,
                  wordSpacing: .5,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}
