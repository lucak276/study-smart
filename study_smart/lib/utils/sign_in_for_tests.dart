import 'package:firebase_auth/firebase_auth.dart';

signInTest() async {
  try {
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
    } else if (e.code == 'wrong-password') {
    }
  }
}


//sign out:
/*

  Future<void> _signOut() async {
                await FirebaseAuth.instance.signOut();
              }

              _signOut();

*/

