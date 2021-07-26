import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_notes/appProvider.dart';

class NotePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff161616),
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (newTitle) {
                    Provider.of<AppProvider>(context, listen: false).title = newTitle;
                  },
                  maxLength: 60,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    counterText: "",
                    contentPadding: EdgeInsets.all(0),
                    hintText: "Title",
                  ),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (newBody) {
                    Provider.of<AppProvider>(context, listen: false).body = newBody;
                  },
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.multiline,
                  maxLength: null,
                  maxLines: null,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(0),
                    hintText: "Note",
                  ),
                ),
              ),
            ],
          ),
        ]
      ),
    );
  }
}
