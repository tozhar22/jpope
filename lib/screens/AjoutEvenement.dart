import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
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
  DateTime? selectedDateTime; // Store selected date and time

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

  Future<void> addEvent() async {
    if (_formKey.currentState!.validate()) {
      List<String> imageUrls = await uploadImagesToFirebase(multiimages);

      final donneEvenement = {
        'evenementName': EvenementNameController.text,
        'organistorName': OrganistorNameController.text,
        'description': descriptionController.text,
        'region': selectRegion,
        'datetime': Timestamp.fromDate(selectedDateTime!),
        'imageUrls': imageUrls,
        'status': 'cree',
        'eventId': '',
      };

      String? userId = AuthenticationService().getCurrentUserId();

      final collectionEvenement = FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .collection('Evenement');

      try {
        final newDocRef = await collectionEvenement.add(donneEvenement);
        String newDocId = newDocRef.id; // Récupérer l'ID généré

        // Mettre à jour l'identifiant unique dans le dictionnaire
        donneEvenement['eventId'] = newDocId;

        // Mettre à jour le document avec l'identifiant unique
        await newDocRef.update(donneEvenement);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("L'événement a été ajouté avec succès !"),
          ),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Une erreur s'est produite lors de l'ajout de l'événement."),
          ),
        );
      }
    }
  }

  Future<List<String>> uploadImagesToFirebase(List<File> images) async {

    List<String> imageUrls = [];

    for (var image in images) {
      String filename = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
      FirebaseStorage.instance.ref().child('event_images/$filename.jpg');
      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask;
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
                  const Text(
                    "CREE UN EVENEMENT",
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF2196F3),
                      fontFamily: 'Russo_One',
                    ),
                  ),
                  const SizedBox(height: 25,),
                  TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Nom de l'Evènement",
                          hintText: "Saisir le nom de l'Evenement",
                          border: OutlineInputBorder()
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ("Vous devez compléter ce champ");
                        }
                        return null;
                      },
                      controller: EvenementNameController
                  ),
                  const SizedBox(height: 25,),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Organisateur",
                        hintText: "Saisir le nom de l'organisateur",
                        border: OutlineInputBorder()
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ("Vous devez compléter ce champ");
                      }
                      return null;
                    },
                    controller: OrganistorNameController,
                  ),
                  const SizedBox(height: 25,),
                  TextFormField(
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: "Description de l'Événement",
                      hintText: "Saisir la description de l'Événement",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vous devez compléter ce champ";
                      }
                      return null;
                    },
                    controller: descriptionController,
                  ),
                  const SizedBox(height: 25,),
                  DropdownButtonFormField(
                      items: const [
                        DropdownMenuItem(
                            value: 'region maritime', child: Text("Maritime")),
                        DropdownMenuItem(
                            value: 'region des Plateaux', child: Text("Plateaux")),
                        DropdownMenuItem(
                            value: 'region centrale', child: Text("Centrale")),
                        DropdownMenuItem(
                            value: 'region de la Kara', child: Text("Kara")),
                        DropdownMenuItem(
                            value: 'region de la savane', child: Text("Savane"))
                      ],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder()
                      ),
                      value: selectRegion,
                      onChanged: (value) {
                        setState(() {
                          selectRegion = value!;
                        });
                      }
                  ),
                  const SizedBox(height: 25,),

                  TextFormField(
                    controller: TextEditingController(
                      text: selectedDateTime != null
                          ? DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!)
                          : '',
                    ),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vous devez compléter ce champ";
                      }
                      return null;
                    },
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: selectedDateTime ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      ).then((date) {
                        if (date != null) {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
                          ).then((time) {
                            if (time != null) {
                              setState(() {
                                selectedDateTime = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                              });
                            }
                          });
                        }
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Date et Heure de evenement",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 25,),
                  ElevatedButton(
                    onPressed: () {
                      multiImagePicker();
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.photo),
                        SizedBox(width: 8.0),
                        Text('Ajouter une affiche'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: (multiimages.length == 1)
                        ? Image.file(File(multiimages[0].path)) // Affiche la seule image en grand.
                        : GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      crossAxisSpacing: 2.5,
                      mainAxisSpacing: 2.5,
                      children: multiimages
                          .map((e) => Image.file(File(e.path)))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed:addEvent,
                        child: const Text(
                          "AJOUTER",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Russo_One',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12,),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey
                        ),
                        child: const Text(
                          "ANNULER",
                          style: TextStyle(
                            color: Color(0xFF2196F3),
                            fontSize: 15,
                            fontFamily: 'Russo_One',
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}