import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'P_create_profile.dart';
import 'buttons.dart';
import 'google_sign_in.dart';
import 'text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Clasa Register
class Register extends StatefulWidget {
  Register({
    super.key,
    required this.onTap,
  });

  final Function()? onTap;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerConfirmPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

//Functia de validare pentru adresa de email
  String? emailRegisterValidation(String? emailAdress) {
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    final isValid = emailRegex.hasMatch(emailAdress ?? '');
    if (!isValid) {
      return 'Adresa de email este invalidă';
    } else {
      return null;
    }
  }

//Functia de validare a parolei
  String? passwordRegisterValidation(String? password) {
    RegExp passwordRegex =
        RegExp(r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$');
    final isValid = passwordRegex.hasMatch(password ?? '');
    if (!isValid) {
      return 'Minim 8 caractere, o literă mare și un caracter special!';
    } else {
      return null;
    }
  }

//Functie de validare a confirmarii parolei
  String? confirmPasswordValidation(String? confirmPassword) {
    if (confirmPassword != controllerPassword.text) {
      return 'Parolele nu coincid';
    }
    return null;
  }

//Functie pentru inregistrare
  void signUp() async {
    if (formKey.currentState!.validate()) {
      //Afisare indicator de incarcare
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });

      //Incercare de inregistrare
      try {
        if (controllerPassword.text != controllerConfirmPassword.text) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Parolele nu coincid'),
            ),
          );
        } else {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: controllerUsername.text,
              password: controllerPassword.text);

          //Redirectionare la pagina de creare profil dupa inregistrarea cu succes
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateProfile()),
          );
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);

        //Gestionarea erorilor
        if (e.code == 'email-already-in-use') {
          incorrectDataMessage('Adresa de email este deja folosită.');
        } else if (e.code == 'weak-password') {
          incorrectDataMessage('Parola este prea slabă.');
        } else {
          incorrectDataMessage('Adresă de email sau parolă incorectă.');
        }
      }
    }
  }

//FUnctie pentru afisarea mesajului de eroare
  void incorrectDataMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('EROARE'),
          content: Text(message),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: const Color.fromARGB(255, 206, 205, 205),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 40),
            Lottie.asset(
              'assets/Animation_Hello.json',
              width: 300,
            ),

            const SizedBox(height: 20),
            const Text(
              'Bine ai venit! Creează un cont',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 12, 73, 123),
              ),
            ),
            const SizedBox(height: 20),

            //Adresa de email
            SizedBox(
              height: 60,
              child: Form(
                key: formKey,
                child: NewTextField(
                  controller: controllerUsername,
                  hintText: 'Email',
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(39, 178, 176, 176),
                  ),
                  obscureText: false,
                  validateText: emailRegisterValidation,
                  noLines: 1,
                ),
              ),
            ),

            //Parola
            SizedBox(
              height: 60,
              child: NewTextField(
                controller: controllerPassword,
                hintText: 'Parolă',
                hintStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(39, 178, 176, 176),
                ),
                obscureText: true,
                validateText: passwordRegisterValidation,
                noLines: 1,
              ),
            ),

            //Confirmare parola
            SizedBox(
              height: 60,
              child: NewTextField(
                controller: controllerConfirmPassword,
                hintText: 'Confirmare parolă',
                hintStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).hintColor,
                ),
                obscureText: false,
                noLines: 1,
                validateText: confirmPasswordValidation,
              ),
            ),

            //Buton de inregistrare
            NewButton(
              text: 'Înregistrează-te',
              onTap: signUp,
            ),

            //Conectare cu Google
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Ai deja un cont? ',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    'Conectează-te!',
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
