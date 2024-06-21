import 'package:flutter/material.dart';

final List<Map<String, String>> faqs = [
  {
    'question': 'După crearea profilului, pot modifica datele introduse?',
    'answer':
        'Da. Actualizarea informațiilor se poate face accesând pagina de setări. Se selectează opțiunea "Editează profilul", se fac modificările dorite și se apasă bifa din colțul din dreapta - sus al ecranului pentru salvare. '
  },
  {
    'question': 'Ce pot face dacă am uitat parola?',
    'answer':
        'Dacă ați uitat parola de la contul dumneavoastră, puteți apăsa pe textul "Ai uitat parola?" de sub câmpul de introducere a parolei din pagina de autentificare. Va fi necesar să menționați adresa de email, pe care se vor trimite pașii următori pentru resetarea parolei.'
  },
  {
    'question': 'Ce evenimente pot fi găsite în această aplicație?',
    'answer':
        'Diverse competiții, concursuri, conferințe și alte evenimente sportive, atât pentru amatori, cât și pentru profesioniști. '
  },
  {
    'question': 'Câte sporturi sunt disponibile?',
    'answer':
        'Peste 20 de sporturi, printre care tenis, fotbal, volei, baschet, ping pong, handbal, alergat, canotaj, înot, lupte, patinaj, schi, atletism, box.'
  },
  {
    'question': 'Cum pot câștiga premii virtuale?',
    'answer':
        'Premiile virtuale pot fi câștigate îndeplinind provocările propuse.'
  },
  {
    'question': 'Unde pot vedea premiile virtuale câștigate?',
    'answer': 'În pagina de vizualizare a profilului.'
  },
  {
    'question': 'Am întâmpinat o problemă, unde mă pot adresa?',
    'answer':
        'Puteți raporta problema dacă accesați pagina de setări și alegeți "Raportează o problemă" sau la adresa de email suport@sport.connect.ro. Echipa noastră vă va contacta în cel mai scurt timp posibil.'
  },
  {
    'question': 'Cum mă pot deconecta/ieși din cont?',
    'answer':
        'Accesând pagina de setări și alegând opțiunea "Deconectează-te" puteți să ieșiți din cont.'
  },
];

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          const Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.question_answer,
                  size: 40,
                  color: Colors.teal,
                ),
                SizedBox(width: 15),
                Text(
                  'Întrebări frecvente',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ...faqs.map((faq) {
            return ExpansionTile(
              title: Text(faq['question']!),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(faq['answer']!),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
