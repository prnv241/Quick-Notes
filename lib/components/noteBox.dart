import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_notes/models/note.dart';
import 'package:my_notes/screens/editNote.dart';
import 'package:my_notes/services/dbops.dart';
import 'package:provider/provider.dart';
import 'package:my_notes/appProvider.dart';
import 'package:sweetsheet/sweetsheet.dart';

class NotesBox extends StatelessWidget {
  final bool left;
  final Note content;
  final int index;
  NotesBox({this.left, this.content, this.index});
  final SweetSheet _sweetSheet = SweetSheet();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Provider.of<AppProvider>(context, listen: false).body =
              Provider.of<AppProvider>(context, listen: false)
                  .notes[index]
                  .body;
          Provider.of<AppProvider>(context, listen: false).title =
              Provider.of<AppProvider>(context, listen: false)
                  .notes[index]
                  .title;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditNotePage()),
          ).then((value) async {
            if (Provider.of<AppProvider>(context, listen: false).body != '') {
              Provider.of<AppProvider>(context, listen: false).updateNote(
                  Provider.of<AppProvider>(context, listen: false)
                      .notes[index]
                      .id,
                  Provider.of<AppProvider>(context, listen: false).title,
                  Provider.of<AppProvider>(context, listen: false).body);

              try {
                await DBHelper().updateNote(
                    Provider.of<AppProvider>(context, listen: false)
                        .notes[index]);
              } catch (e) {
                print(e);
              }
            }
          });
          ;
        },
        onLongPress: () {
          _sweetSheet.show(
            context: context,
            title: Text("Do you really want to delete this note?"),
            description: Text(Provider.of<AppProvider>(context, listen: false)
                .notes[index]
                .title),
            color:
                CustomSheetColor(main: Colors.black12, accent: Colors.black87),
            icon: Icons.delete_forever,
            positive: SweetSheetAction(
              onPressed: () async {
                try {
                  await DBHelper().deleteNote(
                      Provider.of<AppProvider>(context, listen: false)
                          .notes[index]);
                } catch (e) {
                  print(e);
                }
                Provider.of<AppProvider>(context, listen: false).deleteNote(
                    Provider.of<AppProvider>(context, listen: false)
                        .notes[index]
                        .id);

                Navigator.of(context).pop();
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
        },
        child: Container(
          margin: left
              ? EdgeInsets.only(right: 5, bottom: 10)
              : EdgeInsets.only(left: 5, bottom: 10),
          height: 200,
          decoration: BoxDecoration(
              color: Color(0xff161616),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white38)),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        content.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        content.body,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 9,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
