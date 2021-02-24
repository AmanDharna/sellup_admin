import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sellupadmin/models/users.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInAnony() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User firebaseUser = result.user;
      return firebaseUser;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Users _userFromfirebaseUser(User firebaseUser){
    return firebaseUser != null ? Users(uid: firebaseUser.uid) : null;
  }
}
