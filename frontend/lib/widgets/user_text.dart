import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

class UserText extends StatelessWidget {
  const UserText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.3),
          decoration: BoxDecoration(
            color: primaryBlue,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Text(
              "Make HTTP request in Javascript",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  wordSpacing: .5),
            ),
          ),
        ),
      ],
    );
  }
}
