import 'package:flutter/material.dart';

class CircularImageCard extends StatelessWidget {
  CircularImageCard({@required this.image, @required this.scale});

  final String image;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: (1 + scale) * 4,
      clipBehavior: Clip.antiAlias,
      shape: CircleBorder(
          side: BorderSide(color: Colors.grey.shade200, width: 0)),
      child: Padding(
        padding: EdgeInsets.all(8 * (1 + scale)),
        child: Image.asset(
          image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
