import 'package:my_notes/components/padded_button.dart';
import 'package:my_notes/models/user.dart';
import 'package:my_notes/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:my_notes/services/dbops.dart';
import 'package:my_notes/services/netops.dart';
import 'package:uuid/uuid.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  String email;
  String errmsg = '';
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff161616),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff1988e1)),),
        opacity: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(errmsg, style: TextStyle(
                color: Colors.white,
                fontSize: 15
              ),),
              SizedBox(
                height: 15.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kInputFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kInputFieldDecoration.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              PaddedButton(
                btncolor: Colors.lightBlueAccent,
                btntext: 'Log In',
                onPressed: () async{
                  setState(() {
                    showSpinner = true;
                  });
                  var res = await NetHelper().loginUser(email, password);
                  if(res) {
                    CUser newUser = CUser(id: Uuid().v4(), email: email);
                    await DBHelper().userLogged(newUser);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(currUser: newUser,)));
                  } else {
                    setState(() {
                      errmsg = "Please enter a valid username and password!";
                    });
                    print(res);
                  };
                  setState(() {
                    showSpinner = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
