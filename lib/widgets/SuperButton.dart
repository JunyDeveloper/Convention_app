import 'package:flutter/material.dart';

class SuperButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Key parentKey;
  final Function onPress;
  final String text;

  SuperButton(
      {this.parentKey,
      this.onPress,
      this.text,
      this.width = double.infinity,
      this.height = 50.0,
      this.color = Colors.pink});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: double.infinity,
      height: 50.0,
      buttonColor: color,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        elevation: 5,
        child: Container(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
        onPressed: () {
          onPress();
        },
      ),
    );
  }
}
