import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import '../models/Event.dart';
import '../services/FirebaseAuthServices.dart';
import 'PageEvenement.dart';

class EditEvent extends StatefulWidget {
  final Event event;

  const EditEvent({Key? key, required this.event}) : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  late List<Event> events = [];
  final _formKey = GlobalKey<FormState>();
  final EvenementNameController = TextEditingController();
  final OrganistorNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final lieuController = TextEditingController();
  DateTime? selectedDateTime; // Store selected date and time
  String selectVille = 'Lome';
  final ImagePicker _imagePicker = ImagePicker();
  List<File> multiimages = [];
  List<String> currentImageUrls = [];

  @override
  void initState() {
    super.initState();
    loadEventData();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      String userId = AuthenticationService().getCurrentUserId();

      final QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .collection('Evenement')
          .get();

      List<Event> fetchedEvents = eventSnapshot.docs.map((doc) =>
          Event.fromFirestore(doc.id, doc.data() as Map<String, dynamic>)).toList();

      fetchedEvents.sort((a, b) => a.date.compareTo(b.date));

      setState(() {
        events = fetchedEvents;
      });
    } catch (e) {
      print("Erreur lors de la récupération des événements : $e");
    }
  }

  Future<void> multiImagePicker() async {
    final List<XFile> pickedImages = await _imagePicker.pickMultiImage();
    pickedImages.forEach((image) {
      multiimages.add(File(image.path));
    });
    setState(() {});
  }

  Future<List<String>> uploadImagesToFirebase(List<File> images) async {
    List<String> imageUrls = [];

    for (var image in images) {
      String filename = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
      FirebaseStorage.instance.ref().child('event_images/$filename.jpg');

      await storageReference.putFile(image);

      String imageUrl = await storageReference.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    setState(() {
      currentImageUrls.addAll(imageUrls);
    });

    return imageUrls;
  }

  void loadEventData() {
    EvenementNameController.text = widget.event.evenementName;
    OrganistorNameController.text = widget.event.organizerName;
    descriptionController.text = widget.event.description;
    lieuController.text = widget.event.lieu;
    currentImageUrls.addAll(widget.event.imageUrls);
    selectedDateTime = widget.event.date;
    selectVille = widget.event.ville;
    fetchEvents();
  }

  void updateEventData(List<String> imageUrls) {
    String eventName = EvenementNameController.text;
    String organizerName = OrganistorNameController.text;
    String description = descriptionController.text;
    DateTime? selectedDate = selectedDateTime;
    String selectedVille = selectVille;
    String lieu = lieuController.text;

    // Use the data to update the event
    print('Event Name: $eventName');
    print('Organizer Name: $organizerName');
    print('Description: $description');
    print('Selected Date: $selectedDate');
    print('Selected Ville: $selectedVille');
    print('lieu:$lieu');
    print('Updated Image URLs: $imageUrls');
  }

  @override
  void dispose() {
    EvenementNameController.dispose();
    OrganistorNameController.dispose();
    descriptionController.dispose();
    lieuController.dispose();
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
            child: Column(
              children: [
                const Text(
                  "MODIFIER L'ÉVÉNEMENT",
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
                DropdownButtonFormField<String>(
                  items: const [
                    DropdownMenuItem(value: 'Lome', child: Text("Lome")),
                    DropdownMenuItem(value: 'Kara', child: Text("Kara")),
                    DropdownMenuItem(value: 'Atakpamé', child: Text("Atakpamé")),
                    DropdownMenuItem(value: 'Bassar', child: Text("Bassar")),
                    DropdownMenuItem(value: 'Tsévié', child: Text("Tsévié")),
                    DropdownMenuItem(value: 'Aného', child: Text("Aného")),
                    DropdownMenuItem(value: 'Dapaong', child: Text("Dapaong")),
                    DropdownMenuItem(value: 'Tchamba', child: Text("Tchamba")),
                    DropdownMenuItem(value: 'Notsé', child: Text("Notsé")),
                    DropdownMenuItem(value: 'Sotouboua', child: Text("Sotouboua")),
                    DropdownMenuItem(value: 'Vogan', child: Text("Vogan")),
                    DropdownMenuItem(value: 'Biankouri', child: Text("Biankouri")),
                    DropdownMenuItem(value: 'Tabligbo', child: Text("Tabligbo")),
                    DropdownMenuItem(value: 'Amlamé', child: Text("Amlamé")),
                    DropdownMenuItem(value: 'Galangachi', child: Text("Galangachi")),
                    DropdownMenuItem(value: 'Kpagouda', child: Text("Kpagouda")),
                    DropdownMenuItem(value: 'Sokodé', child: Text("Sokodé")),
                    DropdownMenuItem(value: 'Kpalimé', child: Text("Kpalimé")),
                    DropdownMenuItem(value: 'Mango', child: Text("Mango")),
                    DropdownMenuItem(value: 'Niamtougou', child: Text("Niamtougou")),
                    DropdownMenuItem(value: 'Badou', child: Text("Badou")),
                    DropdownMenuItem(value: 'Bafilo', child: Text("Bafilo")),
                    DropdownMenuItem(value: 'Kandé', child: Text("Kandé")),
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  value: selectVille,
                  onChanged: (value) {
                    setState(() {
                      selectVille = value!;
                    });
                  },
                ),
                const SizedBox(height: 25,),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Lieu",
                      hintText: "Saisir le lieu de l'évènement",
                      border: OutlineInputBorder()
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return ("Vous devez compléter ce champ");
                    }
                    return null;
                  },
                  controller: lieuController,
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
                      Text('Modifier l\'affiche'),
                    ],
                  ),
                ),
                // ... display selected images ...
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      List<String> imageUrls =
                      await uploadImagesToFirebase(multiimages);
                      updateEventData(imageUrls);

                      String? userId =
                      AuthenticationService().getCurrentUserId();
                      if (userId != null) {
                        final collectionEvenementCree = FirebaseFirestore
                            .instance
                            .collection('User')
                            .doc(userId)
                            .collection('Evenement_cree');


                        try {
                          await collectionEvenementCree
                              .doc(widget.event.id)
                              .update({
                            'evenementName': EvenementNameController.text,
                            'organistorName': OrganistorNameController.text,
                            'description': descriptionController.text,
                            'ville': selectVille,
                            'datetime': Timestamp.fromDate(selectedDateTime!),
                            'imageUrls': imageUrls,
                            'status': 'cree',
                            'eventId': '',
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                              Text('L\'événement a été modifié avec succès !'),
                            ),
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PageEvenement(),
                            ),
                          );
                        } catch (error) {
                                  print('La modification de l\'événement a échoué $error');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'La modification de l\'événement a échoué. Veuillez réessayer !'),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: const Text(
                    "ENREGISTRER",
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
                  child: const Text(
                    "ANNULER",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Russo_One',
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