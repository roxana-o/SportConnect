import 'package:flutter/material.dart';
import 'P_home_screen2.dart';
import 'P_register.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  
  bool loginPage = true; //Variabila booleana care controleaza daca se afiseaza pagina de autentificare sau de inregistrare

  void toggleLoginLoginOrRegister() {
    setState(() {
      loginPage = !loginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loginPage) {
      return HomeScreen(
        onTap: toggleLoginLoginOrRegister,
      );
    } else {
      return Register(
        onTap: toggleLoginLoginOrRegister,
      );
    }
  }
}
