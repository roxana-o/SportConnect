import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart' as Path;

class AuthentificationControler extends GetxController {
  FirebaseAuth authentication = FirebaseAuth.instance;
  var loadingInformation= false.obs;
  var loading = false.obs;

  Future<void> login({required String email, required String password}) async {
    loading(true);

    try {
      await authentication.signInWithEmailAndPassword(email: email, password: password);
      loading(false);
      Get.to(() => BottomBarView());
    } catch (e) {
      loading(false);
      Get.snackbar('Eroare', e.toString());
    }
  }

  Future<void> register({required String email, required String password}) async {
    loading(true);

    try {
      await authentication.createUserWithEmailAndPassword(email: email, password: password);
      loading(false);
      //Get.to(() => ProfileScreen());
    } catch (e) {
      loading(false);
      Get.snackbar('Eroare', e.toString());
    }
  }

  Future<void> passwordReset(String email) async {
    try {
      await authentication.sendPasswordResetEmail(email: email);
      Get.back();
      Get.snackbar('Email trimis.', 'Verificati email-ul pentru resetarea parolei!');
    } catch (e) {
      Get.snackbar('Eroare', e.toString());
    }
  }

  Future<void> authentificationViaGoogle() async {
    loading(true);

    try {
      final GoogleSignInAccount? user = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? auth = await user?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: auth?.accessToken,
        idToken: auth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      loading(false);
      Get.to(() => BottomBarView());
    } catch (e) {
      loading(false);
      Get.snackbar('Eroare', e.toString());
    }
  }

  Future<String> addImageFirebase(File photo) async {
    String imageUrl = '';
    String fileName = Path.basename(photo.path);

    try {
      var reference = FirebaseStorage.instance.ref().child('photosProfile/$fileName');
      
      UploadTask uploadTask = reference.putFile(photo);
      TaskSnapshot taskSnapshot = await uploadTask;

      imageUrl = await taskSnapshot.ref.getDownloadURL();
      
    } catch (e) {
      Get.snackbar('Eroare', e.toString());
    }

    return imageUrl;
  }

  Future<void> addProfileInformation(String photoURL, String firstName, String lastName,
      String location, String mobileNumber, String birthday) async {
   
    String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'photo': photoURL,
        'name1': firstName,
        'name2': lastName,
        'location': location,
        'mobileNumber': mobileNumber,
        'birthday': birthday,
      });
      loadingInformation(false);
      Get.offAll(() => BottomBarView());
    } catch (e) {
      loadingInformation(false);
      Get.snackbar('Eroare', e.toString());
    }
  }
}

class BottomBarView {
}