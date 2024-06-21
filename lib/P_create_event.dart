import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'buttons.dart';
import 'media.dart';
import 'text_fields.dart';

class CreateNewEvent extends StatefulWidget {
  const CreateNewEvent({super.key});

  @override
  State<CreateNewEvent> createState() => _CreateNewEventState();
}

class _CreateNewEventState extends State<CreateNewEvent> {
  DateTime? date = DateTime.now(); //Data curenta

  //Controlere pentru campurile de text
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPlace = TextEditingController();
  TextEditingController controllerDate = TextEditingController();
  TextEditingController controllerTime = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerTags = TextEditingController();
  TextEditingController controllerStartTime = TextEditingController();
  TextEditingController controllerEndTime = TextEditingController();
  TimeOfDay startTime = const TimeOfDay(hour: 09, minute: 00);
  TimeOfDay endTime = const TimeOfDay(hour: 12, minute: 59);

  //Golire controlere
  void clearControllers() {
    controllerName.clear();
    controllerPlace.clear();
    controllerDate.clear();
    controllerTime.clear();
    controllerPrice.clear();
    controllerDescription.clear();
    controllerTags.clear();
    controllerStartTime.clear();
    controllerEndTime.clear();
    startTime = const TimeOfDay(hour: 0, minute: 0);
    endTime = const TimeOfDay(hour: 0, minute: 0);
    setState(() {});
  }

  var toCreateEvent = false.obs;

  String locations = 'Timiș'; //Judetul selectat implicit
  
  //Lista de judete
  List<String> locationsList = [
    'Alba',
    'Arad',
    'Argeș',
    'Bacău',
    'Bihor',
    'Bistrița-Năsăud',
    'Botoșani',
    'Brăila',
    'Brașov',
    'București',
    'Buzău',
    'Călărași',
    'Caraș-Severin',
    'Cluj',
    'Constanța',
    'Covasna',
    'Dâmbovița' 'Dolj',
    'Galați',
    'Giurgiu',
    'Gorj',
    'Harghita',
    'Hunedoara',
    'Ialomița',
    'Iași',
    'Ilfov',
    'Maramureș',
    'Mehedinți',
    'Mureș',
    'Neamț',
    'Olt',
    'Prahova',
    'Sălaj',
    'Satu Mare',
    'Sibiu',
    'Suceava',
    'Teleorman',
    'Timiș',
    'Tulcea',
    'Vâlcea',
    'Vaslui',
    'Vrancea'
  ];

  String sports = 'Tenis'; //Sportul selectat implicit

  //Lista de sporturi
  List<String> sportsList = [
    'Aerobic',
    'Atletism',
    'Alergat',
    'Badminton',
    'Balet',
    'Baschet',
    'Baseball',
    'Box',
    'Canotaj',
    'Ciclism',
    'Dans',
    'Fotbal',
    'Înot',
    'Judo',
    'Karate',
    'Lupte',
    'Patinaj',
    'Ping Pong',
    'Polo',
    'Rugby',
    'Scrimă',
    'Scufundare',
    'Schi',
    'Surf',
    'Taekwondo',
    'Tenis',
    'Volei'
  ];


  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> mediaLinks = [];
  List<Media> media = [];

  @override
  void initState() {
    super.initState();
    controllerDate.text = '${date!.day}/${date!.month}/${date!.year}';
    controllerTime.text = '${date!.hour}:${date!.minute}/${date!.second}';
  }

  //Functie pentru alegerea datei
  void chooseDate(BuildContext context) async {
    final DateTime? chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2034));

    if (chosenDate != null) {
      date = dateOnly(chosenDate);
      controllerDate.text = '${date!.day}/${date!.month}/${date!.year}';
    }
    setState(() {});
  }

  //Functie pentru obtinere data fara timp
  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  //Functie alegere ora de inceput eveniment
  chooseStartTime(BuildContext context) async {
    final TimeOfDay? chosenTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (chosenTime != null) {
      startTime = chosenTime;
      controllerStartTime.text =
          '${startTime.hourOfPeriod > 9 ? "" : '0'}${startTime.hour > 12 ? '${startTime.hour - 12}' : startTime.hour}:${startTime.minute > 9 ? startTime.minute : '0${startTime.minute}'} ${startTime.hour > 12 ? 'PM' : 'AM'}';
    }
    debugPrint('START ${controllerStartTime.text}');
    setState(() {});
  }

  //Functie alegere ora de sfarsit eveniment
  chooseEndTime(BuildContext context) async {
    final TimeOfDay? chosenTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (chosenTime != null) {
      endTime = chosenTime;
      controllerEndTime.text =
          '${endTime.hourOfPeriod > 9 ? "" : "0"}${endTime.hour > 9 ? "" : "0"}${endTime.hour > 12 ? '${endTime.hour - 12}' : endTime.hour}:${endTime.minute > 9 ? endTime.minute : '0${endTime.minute}'} ${endTime.hour > 12 ? 'PM' : 'AM'}';
    }
    debugPrint('END ${controllerEndTime.text}');
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(5),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 80),
                newText(
                  customText: 'Creează un eveniment',
                  customStyle: const TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                 Container(
                  height: 100,
                  width: 200,
                  child: DottedBorder(
                    color: const Color.fromARGB(179, 110, 107, 107),
                    strokeWidth: 2,
                    dashPattern: const [5, 5],
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            width: 30,
                            height: 30,
                            child: const Icon(Icons.file_upload_outlined),
                          ),
                          customButton(
                            buttonText: 'Încarcă',
                            onPressed: () async {
                              imageInfo(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //Afisare imagini (pentru eveniment) incarcate
                Column(
                  children: [
                    if (media.isNotEmpty) const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: media.map((item) {
                        if (item.isPhoto!) {
                          if (item.photo != null && item.photo is File) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(item.photo as File),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Colors.black.withOpacity(0.5),
                                      child: IconButton(
                                        onPressed: () {
                                          media.remove(item);
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.close,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (item.previewPhoto != null &&
                              item.previewPhoto is Uint8List) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: MemoryImage(
                                      item.previewPhoto as Uint8List),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Colors.black.withOpacity(0.5),
                                      child: IconButton(
                                        onPressed: () {
                                          media.remove(item);
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.close,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                        return Container();
                      }).toList(),
                    ),
                  ],
                ),

                //Denumirea evenimentului
                const SizedBox(height: 20),
                SizedBox(
                  height: 60,
                  child: NewTextField(
                    controller: controllerName,
                    hintText: 'Denumire:',
                    hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).hintColor),
                    obscureText: false,
                    noLines: 1,
                    validateText: (input) {
                      if (input!.isEmpty) {
                        return 'Numele evenimentului este obligatoriu!';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),

                //Locatia evenimentului
                Row(
                  children: [
                    newText(
                      customStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      customText: 'Locație:',
                    ),
                  ],
                ),

                //Listarea locatiilor intr-un dropdown
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: locations,
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        icon: const Icon(Icons.arrow_drop_down_sharp, size: 18),
                        elevation: 15,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                        onChanged: (String? newValue) {
                          setState(() {
                            locations = newValue!;
                          });
                        },
                        items: locationsList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.teal),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                //const SizedBox(height: 20),

                //Adresa evenimentului
                SizedBox(
                  height: 65,
                  child: NewTextField(
                    controller: controllerPlace,
                    hintText: 'Adresă:',
                    hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).hintColor),
                    obscureText: false,
                    noLines: 1,
                    validateText: (input) {
                      if (input!.isEmpty) {
                        return 'Adresa este obligatorie!';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20, width: 40),

                //Data evenimentului
                Row(
                  children: [
                    newText(
                      customStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      customText: 'Data:',
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customField(
                      text: 'Data',
                      isReadOnly: true,
                      iconPath: 'assets/calendar.png',
                      textController: controllerDate,
                      containerWidth: 150,
                      inputValidator: (input) {
                        if (input!.isEmpty) {
                          return 'Data evenimentului este obligatorie!';
                        }
                        return null;
                      },
                      onPressed: () async {
                        chooseDate(context);
                      },
                    ),

                    //Eticheta evenimentului
                    customField(
                      text: '#sport',
                      isReadOnly: false,
                      iconPath: 'assets/hashtag.png',
                      textController: controllerTags,
                      containerWidth: 150,
                      inputValidator: (input) {
                        if (input!.isEmpty) {
                          return 'Etichetele sunt obligatorii!';
                        }
                        return null;
                      },
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                //Intervalul orar al evenimentului
                Row(
                  children: [
                    newText(
                      customStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      customText: 'Interval orar:',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: customField(
                        text: 'Început',
                        isReadOnly: true,
                        iconPath: 'assets/clock.png',
                        textController: controllerStartTime,
                        containerWidth: 150,
                        inputValidator: (input) {
                          if (controllerStartTime.text.isEmpty) {
                            Get.snackbar('Eroare', 'Precizati ora de început!');
                            return '';
                          }
                          return null;
                        },
                        onPressed: () async {
                          chooseStartTime(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: customField(
                        text: 'Final',
                        isReadOnly: true,
                        iconPath: 'assets/clock.png',
                        textController: controllerEndTime,
                        containerWidth: 150,
                        inputValidator: (input) {
                          if (controllerEndTime.text.isEmpty) {
                            Get.snackbar('Eroare', 'Precizati ora de sfârșit!');
                            return '';
                          }
                          return null;
                        },
                        onPressed: () async {
                          chooseEndTime(context);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                //Sportul asociat evenimentului
                Row(
                  children: [
                    newText(
                      customStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      customText: 'Categorie:',
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: sports,
                        padding: EdgeInsets.only(right: 20, left: 20),
                        icon: const Icon(Icons.arrow_drop_down_sharp, size: 18),
                        elevation: 15,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                        onChanged: (String? newValue) {
                          setState(() {
                            sports = newValue!;
                          });
                        },
                        items: sportsList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.teal),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                //Descrierea evenimentului
                Row(
                  children: [
                    newText(
                      customStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      customText: 'Descriere:',
                    ),
                  ],
                ),

                SizedBox(
                  height: 150,
                  child: NewTextField(
                    controller: controllerDescription,
                    hintText: '',
                    hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).hintColor),
                    obscureText: false,
                    noLines: 5,
                    validateText: (input) {
                      if (input!.isEmpty) {
                        return 'Adaugă o scurtă descriere pentru a informa utilizatorul!';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),

                //Buton pentru crearea evenimentului
                customButton(
                  buttonText: 'Creează',
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await saveEvent();
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Functie pentru incarcarea imaginii
  void imageInfo(BuildContext context) async {
    final picker = ImagePicker();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              'Adăugați o imagine:',
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
          content: SingleChildScrollView(
            child: Row(
              children: <Widget>[
                const Padding(padding: EdgeInsets.all(20)),
                GestureDetector(
                  child: const Icon(Icons.camera_alt, size: 40),
                  //Text("Camera"),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      final imageFile = File(pickedFile.path);
                      media.add(Media(photo: imageFile, isPhoto: true));
                      setState(() {});
                    }
                  },
                ),
                const Padding(padding: EdgeInsets.all(20)),
                GestureDetector(
                  child: const Icon(Icons.photo, size: 40),
                  //Text("Galerie"),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      final imageFile = File(pickedFile.path);
                      media.add(Media(photo: imageFile, isPhoto: true));
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Functie pentru salvarea evenimentului in baza de date
  Future<void> saveEvent() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final eventId =
            FirebaseFirestore.instance.collection('events').doc().id;
        final eventData = {
          'name': controllerName.text,
          'place': controllerPlace.text,
          'region': locations,
          'sport': sports,
          'date': dateOnly(date!),
          'startTime': startTime.format(context),
          'endTime': endTime.format(context),
          'description': controllerDescription.text,
          'tags': controllerTags.text,
          'media': await uploadMedia(eventId),
          'userId': user.uid,
        };
        await FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .set(eventData);
        clearControllers();
        Get.snackbar('Succes', 'Evenimentul a fost creat cu succes!');
      } catch (e) {
        Get.snackbar('Eroare', 'A apărut o eroare la crearea evenimentului!');
      }
    } else {
      Get.snackbar('Eroare', 'Utilizator neautentificat!');
    }
  }

  //Functie pentru incarcarea fisierelor media in FirebaseStorage
  Future<List<String>> uploadMedia(String eventId) async {
    final List<String> mediaUrls = [];
    for (final item in media) {
      if (item.photo != null && item.photo is File) {
        final file = item.photo as File;
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
        final storageRef =
            FirebaseStorage.instance.ref().child('events/$eventId/$fileName');
        await storageRef.putFile(file);
        final downloadUrl = await storageRef.getDownloadURL();
        mediaUrls.add(downloadUrl);
      }
    }
    return mediaUrls;
  }
}
