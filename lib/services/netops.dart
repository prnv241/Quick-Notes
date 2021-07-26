import 'package:firebase_auth/firebase_auth.dart';

class NetHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> loginUser(email, password) async {
    try {
      final newUser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (newUser != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> registerUser(email, password) async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (newUser != null) {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> logUserOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch(e) {
      return false;
    }
  }
}
