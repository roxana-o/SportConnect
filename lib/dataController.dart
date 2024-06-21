
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DataManager extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;

  var users = <DocumentSnapshot>[].obs;
  var usersFiltered = <DocumentSnapshot>[].obs;
  var eventsJoined = <DocumentSnapshot>[].obs;

  var events = <DocumentSnapshot>[].obs;
  var eventsFiltered = <DocumentSnapshot>[].obs;

  var loadingUser = false.obs;
  var loadingEvent = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserDocument();
    eventsFetch();
    usersFetch();
  }

 
void fetchUserDocument() {
  if (_auth.currentUser != null) {
    FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).snapshots().listen((event) {
    });
  }
}

void eventsFetch() {
  loadingEvent(true);
  FirebaseFirestore.instance.collection('events').snapshots().listen((event) {
    events.assignAll(event.docs);
    eventsFiltered.assignAll(event.docs);

    eventsJoined.value = events.where((e) {
      List? joinedIds = e.get('joined');
      return joinedIds?.contains(_auth.currentUser?.uid) ?? false;
    }).toList();

    loadingEvent(false);
  });
}

void usersFetch() {
  loadingUser(true);
  FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
    users.value = event.docs;
    usersFiltered.assignAll(event.docs);
    loadingUser(false);
  });
}

}