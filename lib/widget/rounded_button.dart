import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final bool isClickable;

  RoundedButton({@required this.onPressed, @required this.text, this.isClickable = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      child: Container(
        height: MediaQuery.of(context).size.shortestSide * 0.125,
        width: double.infinity,
        child: RaisedButton(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(MediaQuery.of(context).size.shortestSide * 0.15)),
          padding: EdgeInsets.all(8.0),
          color: isClickable ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
          child: isClickable
              ? Text(text,
                  style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.shortestSide * 0.04))
              : SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(),
                ),
          onPressed: isClickable ? onPressed : null,
        ),
      ),
    );
  }
}
