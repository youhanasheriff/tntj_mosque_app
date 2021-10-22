import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? user;
  UserCredential? userCredential;

  User get getUser => user!;

  Future loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );

      userCredential = await _auth.signInWithCredential(credential);
      user = userCredential!.user;
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> loginAnnonymosly() async {
    try {
      userCredential = await _auth.signInAnonymously();
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.disconnect();
    } catch (e) {
      // print(e.toString());
    }
  }
}
