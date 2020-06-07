import "package:firebase_auth/firebase_auth.dart";
import "../models/User.dart";
class Authentication {
  
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> login(StringBuffer username,StringBuffer password) async {
    try{
      await auth.signInWithEmailAndPassword(email: username.toString(), password: password.toString());
      return true;
    }
    catch(e){
      print("Error Incorrect values or $e");
      return false;
    }
    finally{
      username.clear();
      password.clear();
    }
  }

  Future<bool> register(StringBuffer username,StringBuffer password) async {
    try{
      await auth.createUserWithEmailAndPassword(email: username.toString(), password: password.toString());
      return true;
    }
    catch(e){
      print("Error already exists or $e");
      return false;
    }
    finally{
      username.clear();
      password.clear();
    }
  }

  Future<User> currentUser() async {
    FirebaseUser currentUser = await auth.currentUser();
    return User.userFromFirebaseUser(currentUser);
  }
}