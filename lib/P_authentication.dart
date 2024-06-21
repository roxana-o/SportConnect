import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'P_login_or_register.dart';
import 'P_main_page.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MainPage(); //Utilizator autentificat
            } else {
              return const LoginOrRegister(); //Utilizator neautentificat
            }
          }),
    );
  }
}
