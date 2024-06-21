import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//Functie pentru actualizarea evenimentelor la care participa utilizatorul
Future<void> updateAttendingEvents(String eventId) async {
  final user = FirebaseAuth.instance.currentUser!;
  final userDocRef =
      FirebaseFirestore.instance.collection('users').doc(user.uid);

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    DocumentSnapshot userSnapshot = await transaction.get(userDocRef);

    if (!userSnapshot.exists) {
      throw Exception("Nu exista acest utilizator!");
    }

    List<dynamic> attendingEvents = userSnapshot['attendingEvents'] ?? [];

    if (!attendingEvents.contains(eventId)) {
      attendingEvents.add(eventId);
    }

    transaction.update(userDocRef, {'attendingEvents': attendingEvents});
  });
}

//Functie pentru obtinerea numarului de evenimente la care participa utilizatorul
Future<int> getAttendingEventsCount() async {
  final user = FirebaseAuth.instance.currentUser!;
  DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  List<dynamic> attendingEvents = userSnapshot['attendingEvents'] ?? [];
  print('Numarul evenimentelor la care participa: ${attendingEvents.length}');
  return attendingEvents.length;
}

//Clasa pentru pagina de profil a utilizatorului
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

//Functie oentru obtinerea datelor utilizatorului
  Future<Map<String, dynamic>> getUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return userData.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: getUserData(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (userSnapshot.hasError) {
            return const Center(
                child: Text('Eroare la încărcarea datelor utilizatorului.'));
          }
          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return const Center(
                child: Text('Datele utilizatorului nu sunt disponibile.'));
          }

          Map<String, dynamic> userData = userSnapshot.data!;
          String profileImageUrl = userData['photo'] ?? '';
          String firstName = userData['name1'] ?? '';
          String lastName = userData['name2'] ?? '';
          String description =
              userData['description'] ?? 'Nicio descriere adăugată';
          String birthday = userData['birthday'] ?? '';
          String location = userData['location'] ?? '';
          String phoneNumber = userData['mobileNumber'] ?? '';

          return FutureBuilder<int>(
            future: getAttendingEventsCount(),
            builder: (context, eventSnapshot) {
              if (eventSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (eventSnapshot.hasError) {
                return const Center(
                    child: Text('Eroare la încărcarea datelor evenimentului.'));
              }
              if (!eventSnapshot.hasData) {
                return const Center(
                    child: Text('Datele evenimentului nu sunt disponibile.'));
              }

              int attendingEventsCount = eventSnapshot.data!;
              bool hasAttendedThreeEvents = attendingEventsCount >= 3;
              bool hasAttendedFiveEvents = attendingEventsCount >= 5;
              bool hasAttendedTenEvents = attendingEventsCount >= 10;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 120),

                    //Informatii despre utilizator
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : AssetImage('assets/placeholder.png')
                              as ImageProvider,
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '$firstName $lastName',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: const TextStyle(
                          fontSize: 16, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(Icons.cake),
                      title: const Text('Data nașterii'),
                      subtitle: Text(birthday),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_city),
                      title: const Text('Județul'),
                      subtitle: Text(location),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('Numărul de telefon'),
                      subtitle: Text(phoneNumber),
                    ),

                    //Premiile virtuale
                    const ListTile(
                      title: Center(
                        child: Text(
                          'PREMII',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset(
                                hasAttendedThreeEvents
                                    ? 'assets/sigla_bronz_3p.png'
                                    : 'assets/sigla_gri_3p.png',
                                width: 120,
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                              const Text(
                                'Participă la 3 evenimente',
                                style: TextStyle(fontStyle: FontStyle.italic),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset(
                                hasAttendedFiveEvents
                                    ? 'assets/sigla_argint_5p.png'
                                    : 'assets/sigla_gri_5p.png',
                                width: 120,
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                              const Text(
                                'Participă la 5 evenimente',
                                style: TextStyle(fontStyle: FontStyle.italic),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset(
                                hasAttendedTenEvents
                                    ? 'assets/sigla_aur_10p.png'
                                    : 'assets/sigla_gri_10p.png',
                                width: 120,
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                              const Text(
                                'Participă la 10 evenimente',
                                style: TextStyle(fontStyle: FontStyle.italic),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
