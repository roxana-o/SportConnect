# SportConnect - aplicație mobilă 

SportConnect este o aplicație mobilă dezvoltată utilizând limbajul de programare Dart, framework-ul Flutter și serviciile oferite de Google Firebase.

Adresa repository-ului: https://github.com/roxana-o/SportConnect.git

## Precondiții de configurare:
**Dart** <br> (link de instalare: https://dart.dev/get-dart) </br>

**Flutter** cu versiunea 2.0 sau o versiune mai recentă 
<br> (link de instalare: https://flutter.dev/docs/get-started/install) </br>

**Visual Studio Code** sau un alt editor de cod 
<br> (link de instalare: https://code.visualstudio.com/ </br>

**Android Studio** sau un alt mediu de dezvoltare pentru aplicații mobile 
<br> (link de instalare: https://developer.android.com/studio) </br>

## Pași de configurare:

### I. Asigurați-vă că îndepliniți precondițiile prezentate mai sus
1. Consultați ghidul oficial pentru instalarea Dart și Flutter:
   <br> https://docs.flutter.dev/get-started/install/windows/mobile . </br>
2. Instalați tehnologiile care lipsesc.

### II. Instalați componentele plugin Dart și Flutter în Visual Studio Code 
1. Lansați în execuție Visual Studio Code și apăsați pe pictograma _Extensii_ din _Bara de activități_ pentru a merge la secțiunea de extensii.
2. Căutați Dart și apăsați pe _Instalează_.
3. Căutați Flutter și apăsați pe _Instalează_.

### IV. Configurați Flutter
1. Accesați meniul _Terminal > Terminal Nou_ pentru a deschide terminalul.
2. Executați comanda _flutter doctor_ pentru a verifica succesul instalării.

### V. Obțineți aplicația din github 
1. Deschideți terminalul.
2. Executați comanda _git clone https://github.com/roxana-o/SportConnect.git_ pentru a clona repository-ul aplicației.

### VI. Instalați și actualizați dependențele
1. Deschideți terminalul.
2. Executați comanda _flutter pub get_.

### VI. Configurați un dispozitiv virtual
1. Deschideți Android Studio.
2. Accesați _Virtual Device Manager_.
3. Alegeți opțiunea _Create Virtual Device_.
4. Setați proprietățile dispozitivului (definiția dispozitivului, imaginea de sistem, configurația) și dați _Finish_.

### VI. Adăugați dispozitivul în Visual Studio Code
1. Deschideți Visual Studio Code.
2. Apăsați pe mesajul _No device_ din partea de jos a paginii.
3. Alegeți din lista propusă dispozitivul virtual configurat în Android Studio la pasul precedent.

### VI. Lansați aplicația
1. Asigurați-vă că există un dispozitiv virtual adăugat în Visual Studio Code.
2. Apăsați butonul _Run_ pentru a lansa aplicația.

## Foldere și fișiere importante:
**lib** - conține codul sursă al aplicației, fișierul principal este _main.dart_. </br>
**android** - conține configurațiile specifice pentru platforma Android. </br>
**build** - conține fișierele generate automat în timpul procesului de build. </br>
**pubspec.yaml** - fișier care conține informații despre proiect (nume, versiune) și dependențele. </br>
