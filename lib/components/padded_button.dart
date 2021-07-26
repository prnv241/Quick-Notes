import 'package:flutter/material.dart';

class PaddedButton extends StatelessWidget {
  final String btntext;
  final Color btncolor;
  final Function onPressed;

  PaddedButton({this.btncolor, this.btntext, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: btncolor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(btntext, style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}