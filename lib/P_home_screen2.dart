import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'buttons.dart';
import 'google_sign_in.dart';
import 'text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'P_forgot_password.dart';

class HomeScreen extends StatefulWidget {
  final Function()? onTap;
  HomeScreen({
    super.key,
    required this.onTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();

  //Functia pentru autentificare
  void logIn() async {
    //loading
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: controllerUsername.text, password: controllerPassword.text);
      Navigator.pop(context);
    } on FirebaseAuthException {
      Navigator.pop(context);

      incorrectDataMessage(); //Mesaj date incorecte
    }
  }

  //Functie pentru afisare mesaj in caz de date eronate
  void incorrectDataMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Adresă de email sau parolă incorectă.'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: const Color.fromARGB(255, 206, 205, 205),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 30),
            Lottie.asset(
              'assets/Animation_Hello.json',
              width: 300,
            ),

            const SizedBox(height: 20),
            const Text(
              'Mulțumim că alegi SportConnect.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 12, 73, 123),
              ),
            ),

            const Text(
              'Bine ai revenit! ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(
                    255, 12, 73, 123), //Color.fromARGB(255, 244, 153, 18),
              ),
            ),

            //Camp pentru email
            const SizedBox(height: 5),
            Form(
              child: NewTextField(
                controller: controllerUsername,
                hintText: 'Email',
                hintStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(39, 178, 176, 176),
                ),
                obscureText: false,
                noLines: 1,
              ),
            ),

            //Camp pentru parola
            NewTextField(
              controller: controllerPassword,
              hintText: 'Parolă',
              hintStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(39, 178, 176, 176),
              ),
              obscureText: true,
              noLines: 1,
            ),

            //Parola a fost uitata
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ForgotPassword();
                    },
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 22),
                    child: Text(
                      'Ai uitat parola?',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Butonul pentru autentificare
            NewButton(
              text: 'Conectează-te',
              onTap: logIn,
            ),

            //Autentificare cu Google
            GestureDetector(
              onTap: () => AuthentificationService().signInGoogle(),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 0.5,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Continuă cu ',
                        style:
                            TextStyle(color: Color.fromARGB(219, 99, 95, 95)),
                      ),
                    ),
                    Image.asset(
                      'assets/google_logo3.png',
                      width: 30,
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            //Redirectionare catre pagina de inregistrare
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Nu ai cont? ',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    'Înregistrează-te acum',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
