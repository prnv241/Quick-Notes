import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/components/noteBox.dart';
import 'package:provider/provider.dart';
import 'package:my_notes/appProvider.dart';

class NotesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, notesData, child) => ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Color(0xff1988e1),
          child: CupertinoScrollbar(
            child: ListView.builder(
              reverse: false,
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              itemBuilder: (context, index) {
                int curIndex = (index * 2);
                return Row(
                  children: [
                    curIndex < notesData.notes.length ? NotesBox(left: true, content: notesData.notes[curIndex], index: curIndex,) : Container(),
                    curIndex + 1 < notesData.notes.length ? NotesBox(left: false, content: notesData.notes[curIndex + 1], index: curIndex + 1,) : Container(),
                  ],
                );
              },
              itemCount: notesData.notes.length,
            ),
          ),
        ),
      ),
    );
  }
}
