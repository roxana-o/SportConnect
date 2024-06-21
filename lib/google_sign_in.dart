import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

//Autentificare cu Google
class AuthentificationService {
  signInGoogle() async {

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuthentification =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuthentification.accessToken,
      idToken: googleAuthentification.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
