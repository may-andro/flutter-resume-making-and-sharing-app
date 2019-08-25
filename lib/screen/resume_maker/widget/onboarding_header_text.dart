import 'package:flutter/material.dart';
import 'package:resumepad/utility/color_utility.dart';

class OnBoardingHeaderText extends StatelessWidget {
  final String text;

  const OnBoardingHeaderText({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Text(
        text,
        style: TextStyle(
            color: Color(getColorHexFromStr(TEXT_COLOR_BLACK)),
            fontSize: MediaQuery.of(context).size.shortestSide * 0.07,
            letterSpacing: 0.8),
        softWrap: true,
        textAlign: TextAlign.left,
      ),
    );
  }
}
