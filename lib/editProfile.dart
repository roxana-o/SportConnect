import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

//Functie incarcare date utilizator din FirebaseFirestore
  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (userData.exists) {
      Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
      setState(() {
        _firstNameController.text = data['name1'] ?? '';
        _lastNameController.text = data['name2'] ?? '';
        _descriptionController.text = data['description'] ?? '';
        _birthdayController.text = data['birthday'] ?? '';
        _locationController.text = data['location'] ?? '';
        _phoneNumberController.text = data['mobileNumber'] ?? '';
        _profileImageUrl = data['photo'] ?? '';
      });
    }
  }

//Functie actualizare date in FirebaseFirestore
  Future<void> updateUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    Map<String, dynamic> updatedData = {
      'name1': _firstNameController.text,
      'name2': _lastNameController.text,
      'description': _descriptionController.text,
      'birthday': _birthdayController.text,
      'location': _locationController.text,
      'mobileNumber': _phoneNumberController.text,
    };

    //Incarca si actualizeaza imaginea de profil
    if (_image != null) {
      String fileName = 'profile_pictures/${user.uid}.jpg';
      UploadTask uploadTask =
          FirebaseStorage.instance.ref(fileName).putFile(_image!);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      updatedData['photo'] = imageUrl;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update(updatedData);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Datele au fost actualizate cu succes')));
    Navigator.of(context).pop();
  }

//Functie pentru selectarea unei imagini din galerie
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editează Profilul'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: updateUserData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            //Apasare pe imagine pentru alegere una noua
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 60,
                //Afiseaza imaginea selectata
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty
                            ? NetworkImage(_profileImageUrl!)
                            : AssetImage('assets/placeholder.png'))
                        as ImageProvider,
                backgroundColor: Colors.grey[200],
              ),
            ),

            //Campuri text pentru editarea datelor
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'Prenume'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Nume'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descriere'),
              maxLines: 3,
            ),
            TextField(
              controller: _birthdayController,
              decoration: InputDecoration(labelText: 'Data nașterii'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Județul'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Numărul de telefon'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }
}
