import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'P_create_event.dart';
import 'P_home.dart';
import 'P_my_profile.dart';
import 'P_search_event.dart';
import 'P_settings.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final user = FirebaseAuth.instance.currentUser!;

  int index = 0; //Variabila pentru indexul paginii

//Listare pagini disponibile in bara de navigare
  List navPages = [
    HomePage(),
    EventListScreen(),
    const CreateNewEvent(),
    const ProfilePage(),
    const SettingsPage(),
  ];

  //Deconectarea de la cont
  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navPages[index], //Afiseaza pagina corespunzatoare indexului curent din bara de cautare
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Color.fromARGB(169, 158, 158, 158),
            padding: const EdgeInsets.all(15),
            gap: 5,
            selectedIndex: index, //Indexul paginii selectate in bara de navigare
            onTabChange: (value) {
              setState(() {
                index = value; //Actualizare index
              });
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Acasă',
              ),
              GButton(
                icon: Icons.search,
                text: 'Căutare',
              ),
              GButton(
                icon: Icons.add,
                text: 'Adăugare',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profil',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Setări',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
