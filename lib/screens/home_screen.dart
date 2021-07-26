import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/components/listNotes.dart';
import 'package:my_notes/models/note.dart';
import 'package:my_notes/models/user.dart';
import 'package:my_notes/screens/note_screen.dart';
import 'package:my_notes/screens/welcome_screen.dart';
import 'package:my_notes/services/dbops.dart';
import 'package:my_notes/services/netops.dart';
import 'package:my_notes/services/sync.dart';
import 'package:provider/provider.dart';
import 'package:my_notes/appProvider.dart';
import 'package:sweetsheet/sweetsheet.dart';

class HomePage extends StatelessWidget {
  final CUser currUser;
  HomePage({this.currUser});
  final SweetSheet _sweetSheet = SweetSheet();
  void setUpPage(context) async{
    Provider.of<AppProvider>(context, listen: false).user = currUser;
    List<Note> notes = await DBHelper().getNotes();
    Provider.of<AppProvider>(context, listen: false).updateAppData(notes);
    syncLocalDB(context, true);
    final cron = Cron();
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      syncLocalDB(context, false);
    });
  }
  @override
  Widget build(BuildContext context) {
    setUpPage(context);
    return Scaffold(
      backgroundColor: Color(0xff161616),
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Image.asset('images/logout.png', height: 25,),
              onPressed: () async{
                _sweetSheet.show(
                  context: context,
                  title: Text("Do you really want to logout?"),
                  description: Text(Provider.of<AppProvider>(context, listen: false)
                      .user.email),
                  color:
                  CustomSheetColor(main: Colors.black12, accent: Colors.black87),
                  icon: Icons.power_settings_new,
                  positive: SweetSheetAction(
                    onPressed: () async {
                      if(await NetHelper().logUserOut()) {
                        await DBHelper().logOutUser();
                      }
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
                    },
                    title: 'CONTINUE',
                  ),
                  negative: SweetSheetAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    title: 'CANCEL',
                  ),
                );
              }),
        ],
        title: Text('Quick Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 25,
        ),
        backgroundColor: Color(0xff1988e1),
        onPressed: () async{
          Provider.of<AppProvider>(context, listen: false).title = '';
          Provider.of<AppProvider>(context, listen: false).body = '';
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotePage()),
          ).then((value) async{
            if (Provider.of<AppProvider>(context, listen: false).body != '') {
              Provider.of<AppProvider>(context, listen: false).addNote(
                  Provider.of<AppProvider>(context, listen: false).title,
                  Provider.of<AppProvider>(context, listen: false).body);
              try {
                await DBHelper().insertNote(Provider.of<AppProvider>(context, listen: false).notes.last);
              } catch(e) {
                print(e);
              }
            }
          });
        },
      ),
      body: NotesList(),
    );
  }
}
