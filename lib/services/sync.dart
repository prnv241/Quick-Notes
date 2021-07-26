import 'dart:io';
import 'package:my_notes/appProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_notes/models/note.dart';
import 'package:my_notes/models/ops.dart';
import 'package:my_notes/services/dbops.dart';
import 'package:provider/provider.dart';
User loggedInUser;

Future<void> syncLocalDB(context, init) async{
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      final _firestore = FirebaseFirestore.instance;
      final _auth = FirebaseAuth.instance;
      String userEmail = getCurrentUser(_auth);
      if(userEmail != '') {
        List<Operation> operations = await DBHelper().pendingOps();
        for(int i = 0; i<operations.length; i++) {
          Operation op = operations[i];
          switch(op.operation) {
            case 'INSERT':
              Map<String, dynamic> newNote = Note(id: op.noteid, title: op.title, body: op.body, userid: userEmail).toMap();
              _firestore.collection('notes').doc(op.noteid).set(newNote);
              break;

            case 'UPDATE':
              Map<String, dynamic> noteUpdate = Note(id: op.noteid, title: op.title, body: op.body, userid: userEmail).toMap();
              _firestore.collection('notes').doc(op.noteid).update(noteUpdate);
              break;

            case 'DELETE':
              _firestore.collection('notes').doc(op.noteid).delete();
              break;
          }
        }
        await DBHelper().clearOps();
        if(init) {
          List<Note> updatedList = [];
          _firestore.collection('notes').where('userid', isEqualTo: Provider.of<AppProvider>(context, listen: false).user.email).get().then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              updatedList.add(Note(title: doc["title"], userid: doc["userid"],id: doc["id"], body: doc["body"]));
            });
            Provider.of<AppProvider>(context, listen: false).updateAppData(updatedList);
          });
        }
      }
    }
  } on SocketException catch (_) {
    print('not connected');
  }
}


String getCurrentUser(_auth) {
  try {
    final user = _auth.currentUser;
    if(user != null) {
      loggedInUser = user;
      return loggedInUser.email;
    }
  } catch(e) {
    print(e);
    return '';
  }
}