import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/widgets/triangle.dart';

class SentMessage extends StatelessWidget {
  final String message;

  const SentMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final messageTextGroup = Flexible(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Monstserrat', fontSize: 16),
            ),
          ),
        ),
        CustomPaint(painter: Triangle(primaryColor)),
      ],
    ));

    return Padding(
      padding: EdgeInsets.only(right: 18.0, left: 50, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 30),
          messageTextGroup,
        ],
      ),
    );
  }
}
