import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'P_help.dart';
import 'P_terms_and_conditions.dart';
import 'Provider/themes.dart';
import 'editProfile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser!;

//Functia de deconectare
  void logOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sigur dorești să te deconectezi de la cont?',
              style: TextStyle(fontSize: 15)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Anulează'),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
              child: const Text('Deconectare'),
            ),
          ],
        );
      },
    );
  }

  // Funcție pentru trimiterea recenziei
  void sendReview(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Trimite o recenzie'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Scrie un mesaj:'),
            maxLines: null,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Anulează'),
            ),
            ElevatedButton(
              onPressed: () async {
                String problemDescription = controller.text;

                if (problemDescription.isNotEmpty) {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'roxana.olaru14@gmail.com',
                    queryParameters: {
                      'subject': 'Feedback',
                      'body': problemDescription,
                    },
                  );

                  if (await canLaunchUrl(emailLaunchUri)) {
                    await launchUrl(emailLaunchUri);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Feedback-ul a fost trimis cu succes. Mulțumim!'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Nu se poate trimite emailul. Vă rugăm să încercați din nou mai târziu'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vă rugăm să ne trimiteți o recenzie.'),
                    ),
                  );
                }
              },
              child: const Text('Trimite'),
            ),
          ],
        );
      },
    );
  }

  // Funcție pentru raportarea problemei
  void reportProblem(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Raportează o problemă'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Descrieți problema:'),
            maxLines: null,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Anulează'),
            ),
            ElevatedButton(
              onPressed: () async {
                String problemDescription = controller.text;

                if (problemDescription.isNotEmpty) {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'roxana.olaru14@gmail.com',
                    queryParameters: {
                      'subject': 'Raportare problemă',
                      'body': problemDescription,
                    },
                  );

                  if (await canLaunchUrl(emailLaunchUri)) {
                    await launchUrl(emailLaunchUri);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Raportul a fost trimis cu succes. Mulțumim!'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Nu se poate trimite emailul. Vă rugăm să încercați din nou mai târziu'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Vă rugăm să introduceți descrierea problemei.'),
                    ),
                  );
                }
              },
              child: const Text('Trimite'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Consumer<Themes>(
              builder: (context, Themes notify, child) {
                return Column(
                  children: [
                    //Schimbare tema (mod intunecat/luminos)
                    ListTile(
                      title: const Text('Mod întunecat'),
                      leading: const Icon(Icons.dark_mode),
                      trailing: Switch(
                        value: notify.dark,
                        onChanged: (value) => notify.changeTheme(),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            SettingsGroup(
              title: 'GENERAL',
              children: <Widget>[
                accountOption(context),
                editProfileOption(context),
                logoutOption(context),
              ],
            ),
            const SizedBox(height: 20),
            SettingsGroup(
              title: 'MAI MULTE',
              children: <Widget>[
                reportOption(context),
                feedbackOption(context),
                helpOption(context),
              ],
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
    );
  }

//Widget pentru editarea profilului
  Widget editProfileOption(BuildContext context) => SimpleSettingsTile(
        title: 'Editează profilul',
        leading: const Icon(Icons.person),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EditProfilePage()),
          );
        },
      );

//Widget pentru optiunile contului
  Widget accountOption(BuildContext context) => SimpleSettingsTile(
        title: 'Administrare cont',
        subtitle: 'Confidențialitate, Termeni și Condiții',
        leading: const Icon(Icons.tune),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LegalPage()),
          );
        },
      );

//Widget pentru deconectare
  Widget logoutOption(BuildContext context) => SimpleSettingsTile(
        title: 'Deconectează-te',
        leading: Icon(Icons.logout),
        onTap: () => logOut(context),
      );

//Widget pentru raportare problema
  Widget reportOption(BuildContext context) => SimpleSettingsTile(
        title: 'Raportează o problemă',
        leading: Icon(Icons.report),
        onTap: () => reportProblem(context),
      );

//Widget pentru recenzie
  Widget feedbackOption(BuildContext context) => SimpleSettingsTile(
        title: 'Trimite o recenzie',
        leading: Icon(Icons.feedback),
        onTap: () => sendReview(context),
      );

//Widget pentru centrul de suport
  Widget helpOption(BuildContext context) => SimpleSettingsTile(
        title: 'Centru de suport',
        leading: Icon(Icons.question_mark),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => HelpPage()),
          );
        },
      );
}
