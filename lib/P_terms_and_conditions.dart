import 'package:flutter/material.dart';

const String termsAndConditions = '''
1. Introducere
   Acesta este un acord între dumneavoastră și SportConnect. Utilizarea acestei aplicații presupune acceptarea acestor termeni și condiții.

2. Utilizarea aplicației
   Aplicația este destinată utilizării personale. Este interzisă folosirea în scopuri comerciale fără permisiunea noastră scrisă.

3. Cont utilizator
   Sunteți responsabil pentru confidențialitatea informațiilor contului dumneavoastră și pentru toate activitățile care au loc sub contul dumneavoastră.

4. Limitarea răspunderii
   SportConnect nu este responsabilă pentru eventualele pierderi sau daune rezultate din utilizarea aplicației.

5. Modificări
   Ne rezervăm dreptul de a modifica acești termeni în orice moment. Vă vom notifica cu privire la modificări prin actualizarea termenilor pe această pagină.

6. Contact
   Pentru orice întrebări legate de acești termeni, ne puteți contacta la suport@sport.connect.ro.
''';

const String privacyPolicy = '''
1. Introducere
   Această politică explică modul în care colectăm, folosim și protejăm informațiile dumneavoastră personale.

2. Colectarea informațiilor
   Colectăm informații personale atunci când creați un cont, utilizați aplicația sau contactați suportul nostru.

3. Utilizarea informațiilor
   Informațiile colectate sunt folosite pentru a îmbunătăți serviciile noastre și pentru a comunica cu dumneavoastră.

4. Partajarea informațiilor
   Nu partajăm informațiile dumneavoastră personale cu terți, cu excepția cazului în care acest lucru este necesar pentru furnizarea serviciilor noastre sau este cerut de lege.

5. Securitatea informațiilor
   Luăm măsuri pentru a proteja informațiile dumneavoastră personale împotriva accesului neautorizat și a utilizării incorecte.

6. Modificări
   Ne rezervăm dreptul de a modifica această politică de confidențialitate în orice moment. Vă vom notifica cu privire la modificări prin actualizarea politicii pe această pagină.

7. Contact
   Pentru orice întrebări legate de această politică de confidențialitate, ne puteți contacta la suport@sport.connect.ro.
''';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termeni și Condiții'),
        backgroundColor: Colors.teal,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          termsAndConditions,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Politica de Confidențialitate'),
        backgroundColor: Colors.teal,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          privacyPolicy,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}

class LegalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termeni și Politici'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.description, color: Colors.teal),
            title: const Text('Termeni și Condiții'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TermsAndConditionsPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.teal),
            title: const Text('Politica de Confidențialitate'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacyPolicyPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
