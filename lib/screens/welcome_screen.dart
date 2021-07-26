import 'package:my_notes/components/padded_button.dart';
import 'package:my_notes/screens/login_screen.dart';
import 'package:my_notes/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff161616),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ["Quick Notes"],
                  speed: Duration(seconds: 1),
                  textStyle: TextStyle(
                    fontSize: 42.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            PaddedButton(
              btncolor: Colors.lightBlueAccent,
              btntext: 'Log In',
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
            PaddedButton(
              btncolor: Colors.blueAccent,
              btntext: 'Register',
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
