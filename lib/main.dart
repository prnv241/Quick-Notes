import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/appProvider.dart';
import 'package:my_notes/models/user.dart';
import 'package:my_notes/screens/home_screen.dart';
import 'package:my_notes/screens/welcome_screen.dart';
import 'package:my_notes/services/dbops.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: AppInitializer()
    );
  }
}

class AppInitializer extends StatefulWidget {
  @override
  _AppInitializerState createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  Widget screen = Scaffold(backgroundColor: Color(0xff161616));
  void setScreen() async{
    List<CUser> users = await DBHelper().getUser();
    setState(() {
      if(users.length > 0) screen = HomePage(currUser: users[0],);
      else screen = WelcomeScreen();
    });
  }
  @override
  void initState() {
    super.initState();
    setScreen();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark().copyWith(textSelectionHandleColor: Color(0xff1988e1)),
      themeMode: ThemeMode.dark,
      title: 'My Notes',
      home: screen,
    );
  }
}

