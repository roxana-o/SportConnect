import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'text_fields.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final controllerEmail = TextEditingController();

  @override
  void dispose() {
    controllerEmail.dispose();
    super.dispose();
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: controllerEmail.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                'Verifică adresa de email și urmează pașii pentru a reseta parola!',
                textAlign: TextAlign.center,
              ),
            );
          });
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 12, 73, 123),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Adaugă adresa de email pentru a reseta parola:'),
          NewTextField(
            controller: controllerEmail,
            hintText: 'Email',
            obscureText: false,
            noLines: 1,
          ),
          const SizedBox(height: 10),
          MaterialButton(
            onPressed: resetPassword,
            color: const Color.fromARGB(255, 12, 73, 123),
            child: const Text('Resetează parola',
                style: TextStyle(color: Color.fromARGB(255, 224, 222, 222))),
          ),
        ],
      ),
    );
  }
}
