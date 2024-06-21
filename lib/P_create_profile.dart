import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_project/controllerAuth.dart';
import 'package:my_project/text_fields.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({ super.key });

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {

  GlobalKey <FormState> key = GlobalKey<FormState>();

  AuthentificationControler? controllerAuthentification;
  File? photoProfile;
  DateTime? date = DateTime.now();

  TextEditingController controllerFirstName = TextEditingController();
  TextEditingController controllerLastName = TextEditingController();
  TextEditingController controllerNumber = TextEditingController();
  TextEditingController controllerLocation =   TextEditingController();
  TextEditingController controllerBirthday = TextEditingController();

   @override
  void initState() {
    super.initState();
    controllerBirthday.text = '${date!.day}/${date!.month}/${date!.year}';
    controllerAuthentification =AuthentificationControler();
  }

  Future <Null> chooseDate(BuildContext context) async {
    final DateTime? chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1924),
        lastDate: DateTime.now());

    if (chosenDate != null) {
      controllerBirthday.text = '${chosenDate.day}/${chosenDate.month}/${chosenDate.year}';
    }
    setState(() {});
  }

  imagePickDialog(){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adaugă o fotografie de profil'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  final ImagePicker choose = ImagePicker();
                  final XFile? photo = await choose.pickImage(
                    source: ImageSource.camera,
                    );

                    if (photo != null) {
                      photoProfile = File(photo.path);
                      setState(() {});
                      Navigator.pop(context);
                    }
                },

                child: const Icon(
                  size:20,
                  Icons.camera_alt,
                ),
              ),

              InkWell(
                onTap: () async {
                  final ImagePicker choose = ImagePicker();
                  final XFile? photo = await choose.pickImage(
                    source: ImageSource.gallery,
                    );

                    if (photo != null) {
                      photoProfile = File(photo.path);
                      setState(() {});
                      Navigator.pop(context);
                    }
                },

                child: const Icon(
                  size:20,
                  Icons.photo,
                ),
              ),


            ],
           
            )
        );
      }
      );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          
          child: Form(
            key: key,

              child: Column(
                
                children: [
                  //const SizedBox(height: 20),
              
                  InkWell(
                    onTap: () {
                      imagePickDialog();
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      child: photoProfile == null
                          ? const Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                              size: 50,
                            )
                          : ClipOval(
                              child: Image.file(
                                photoProfile!,
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                              ),
                            ),
                    ),
                  ),
                 
              
                  SizedBox(
                    height: 70,
                    child: NewTextField(
                      hintText: 'Nume*',
                      obscureText: false,
                      
                      controller: controllerFirstName,
                       hintStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(39, 195, 193, 193)),
                      noLines: 1,
                      validateText: (input) {
                        if (input!.isEmpty) {
                          return 'Numele este obligatoriu!';
                        }
                        return null;
                      },
                    ),
                  ),
                

                   SizedBox(
                    height: 70,
                     child: NewTextField(
                      hintText: 'Prenume*',
                      obscureText: false,
                      controller: controllerLastName,
                      noLines: 1,
                      hintStyle: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(39, 195, 193, 193)),
                      validateText: (input) {
                        if (input!.isEmpty) {
                          return 'Prenumele este obligatoriu!';
                        }
                        return null;
                      },
                                       ),
                   ),
                 // SizedBox(height: 20),
                   SizedBox(
                    height: 70,
                     child: NewTextField(
                      hintText: 'Județ*',
                      obscureText: false,
                      controller: controllerLocation,
                      noLines: 1,
                      hintStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(39, 195, 193, 193)),
                          
                      validateText: (input) {
                        if (input!.isEmpty) {
                          return 'Județul este obligatoriu!';
                        }
                        return null;
                      },
                                       ),
                   ),
              
                  SizedBox(
                    height: 70,
                    child: NewTextField(
                      hintText: 'Telefon*',
                      obscureText: false,
                      controller: controllerNumber,
                      noLines: 1,
                      inputType: TextInputType.phone,
                      hintStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(39, 195, 193, 193)),
                          
                          
                      validateText: (input) {
                        
                        if (input!.isEmpty) {
                          return 'Numărul de telefon este obligatoriu!';
                        }
                        if (input.length != 10) {
                          return 'Număr de telefon invalid! Ex valid: 0712345678';
                        }
                        return null;
                      },
                    ),
                  ),
                  
              
                    Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
                    child: SizedBox(
                     // height: 40,
                      child: TextFormField(
                        controller: controllerBirthday,
                        obscureText: false,
                        style: TextStyle(
              color:Colors.black,
              ),
                
              decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              fillColor: const Color.fromARGB(247, 231, 222, 222),
              filled: true,
              hintText: 'Data nașterii',
                        ),
                         
                        
                         onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
              
                       chooseDate(context);
                      },
                      ),
                    ),
                  ),
              
              
                  
              
                  Obx(
                    () => controllerAuthentification!.loadingInformation.value
                        ? const CircularProgressIndicator()
                        : Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(20),
                            child: ElevatedButton(
                              onPressed: () async {
                               
              
                                if (!key.currentState!.validate()) {
                                  return;
                                }
              
                                if (photoProfile == null) {
                                  Get.snackbar(
                                    '',
                                    'Poza este obligatorie.',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.blue,
                                  );
                                  return;
                                }
              
                                controllerAuthentification!.loadingInformation(true);
              
                                String imageUrl = await controllerAuthentification!
                                    .addImageFirebase(photoProfile!);
              
                                controllerAuthentification!.addProfileInformation(
                                  imageUrl,
                                  controllerFirstName.text.trim(),
                                  controllerLastName.text.trim(),
                                  controllerLocation.text.trim(),
                                  controllerNumber.text.trim(),
                                  controllerBirthday.text.trim(),
                                  
                                );
                              },
                              child: const Text('Salvare'),
                            ),
                          ),
                  ),
                 // const SizedBox(height: 20),
              
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Prin înregistrare vă exprimați acordul privind ',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          TextSpan(
                            text: 'Termenii și Condițiile de Utilizare',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            
          ),
        ),

      ),
    );
  }
  }
