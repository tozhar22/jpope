/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jpope/services/FirebaseAuthServices.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _formKey = GlobalKey<FormState>();
  final EvenementNameController = TextEditingController();
  final OrganistorNameController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime selectDate = DateTime.now();
  TimeOfDay selectTime = TimeOfDay.now(); // Ajoutez cette ligne pour stocker l'heure

  String selectRegion = 'region maritime';

  final ImagePicker _imagePicker = ImagePicker();
  List<File> multiimages = [];

  multiImagePicker() async {
    final List<XFile> pickedImage = await _imagePicker.pickMultiImage();
    pickedImage.forEach((e) {
      multiimages.add(File(e.path));
    });
    setState(() {});
  }

  // Méthode pour enregistrer les images
  Future<List<String>> uploadImagesToFirebase(List<File> images) async {
    List<String> imageUrls = [];

    for (var image in images) {
      // Créez un nom de fichier unique pour chaque image
      String filename = DateTime.now().millisecondsSinceEpoch.toString();

      // Référence à l'image dans Firebase Storage
      Reference storageReference =
      FirebaseStorage.instance.ref().child('event_images/$filename.jpg');

      // Téléversez l'image vers Firebase Storage
      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask;

      // Obtenez l'URL de téléchargement de l'image
      String imageUrl = await storageReference.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    return imageUrls;
  }

  @override
  void dispose() {
    EvenementNameController.dispose();
    OrganistorNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ... autres champs de saisie et widgets
                  DateTimeFormField(
                    // ... autres propriétés
                    mode: DateTimeFieldPickerMode.dateAndTime,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (e) =>
                    (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                    onDateSelected: (DateTime value) {
                      setState(() {
                        selectDate = value;
                      });
                    },
                    onTimeSelected: (TimeOfDay value) {
                      setState(() {
                        selectTime = value;
                      });
                    },
                  ),
                  // ... autres widgets
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            List<String> imageUrls =
                            await uploadImagesToFirebase(multiimages);

                            final DonneEvenement = {
                              // ... autres propriétés
                              'date': Timestamp.fromDate(
                                  selectDate.add(Duration(
                                      hours: selectTime.hour,
                                      minutes: selectTime.minute))),
                              'imageUrls': imageUrls,
                            };

                            String? userId =
                            AuthenticationService().getCurrentUserId();

                            final collectionEvementCree = FirebaseFirestore
                                .instance
                                .collection('User')
                                .doc(userId)
                                .collection('Evenement_cree');
                            try {
                              await collectionEvementCree.add(DonneEvenement);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "L'événement a été ajouté avec succès !"),
                                ),
                              );
                              Navigator.pop(context, true);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Une erreur s'est produite lors de l'ajout de l'événement."),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          "AJOUTER",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Russo_One',
                          ),
                        ),
                      ),
                      // ... autres boutons et widgets
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

*/
