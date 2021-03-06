import 'package:firebase_auth/firebase_auth.dart';
import 'package:modulate_vsc/src/firebase/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in with email
  Future signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      await DatabaseService(user.uid).createUserData(null, user.email);
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "user";
      } else if (e.code == 'wrong-password') {
        return "password";
      }
    }
  }

  Future signUpWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      await DatabaseService(user.uid).createUserData(null, user.email);
    } catch (e) {
      print("something went wrong $e");
    }
  }
}
