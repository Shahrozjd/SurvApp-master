import 'package:flutter/material.dart';

class RectButton extends StatelessWidget {
  String textval;
  double height;
  double width;
  Function onpress;

  RectButton({this.textval, this.height, this.width, this.onpress});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      elevation: 5.0,
      child: MaterialButton(
        padding: EdgeInsets.all(10),
        minWidth: 100,
        height: 40,
        splashColor: Colors.transparent,
        onPressed: onpress,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          textval,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
