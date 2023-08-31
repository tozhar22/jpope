import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import '../models/Event.dart';
import '../services/FirebaseAuthServices.dart';

class EditEvent extends StatefulWidget {
  final Event event;

  const EditEvent({Key? key, required this.event}) : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  late Event editedEvent;
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
  bool _isLoading = false;

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

  /*Future<void> multiImagePicker() async {
    final List<XFile> pickedImages = await _imagePicker.pickMultiImage();
    pickedImages.forEach((image) {
      multiimages.add(File(image.path));
    });
    setState(() {});
  }*/
  Future<void> _refreshEvents() async {
    await fetchEvents();
    setState(() {});
  }

  Future<void> multiImagePicker() async {
    final List<XFile> pickedImages = await _imagePicker.pickMultiImage();

    if (pickedImages.isNotEmpty) {
      multiimages.clear(); // Clear the previous images
      currentImageUrls.clear(); // Clear the previous image URLs

      for (var image in pickedImages) {
        multiimages.add(File(image.path));

        String imageUrl = (await uploadImageToFirebase(image as File));
        currentImageUrls.add(imageUrl); // Add the new image URL to currentImageUrls
      }

      setState(() {});
      _refreshEvents();
    }
  }

  Future<String> uploadImageToFirebase(File image) async {
    String filename = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
    FirebaseStorage.instance.ref().child('event_images/$filename.jpg');

    await storageReference.putFile(image);

    String imageUrl = await storageReference.getDownloadURL();
    return imageUrl;
  }


  /*Future<List<String>> uploadImagesToFirebase(List<File> images) async {
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
  }*/

  void loadEventData() {
    editedEvent = widget.event; // Initialize editedEvent with the event data
    EvenementNameController.text = editedEvent.evenementName;
    OrganistorNameController.text = editedEvent.organizerName;
    descriptionController.text = editedEvent.description;
    lieuController.text = editedEvent.lieu;
    currentImageUrls.addAll(editedEvent.imageUrls);
    selectedDateTime = editedEvent.date;
    selectVille = editedEvent.ville;
    //multiimages.addAll(editedEvent.imageUrls.map((imageUrl) => File(imageUrl)));

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
      body: RefreshIndicator(
        onRefresh: _refreshEvents,
        child: Stack(
            children: [SingleChildScrollView(
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
                        controller: EvenementNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ("Vous devez compléter ce champ");
                          }
                          return null;
                        },

                      ),
                      const SizedBox(height: 25,),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Organisateur",
                            hintText: "Saisir le nom de l'organisateur",
                            border: OutlineInputBorder()
                        ),
                        controller: OrganistorNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ("Vous devez compléter ce champ");
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25,),
                      TextFormField(
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: "Description de l'Événement",
                          hintText: "Saisir la description de l'Événement",
                          border: OutlineInputBorder(),
                        ),
                        controller: descriptionController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vous devez compléter ce champ";
                          }
                          return null;
                        },
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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


                      Column(
                        children: [
                          if (currentImageUrls.isNotEmpty)
                            Image.network(currentImageUrls.first),
                          const SizedBox(height: 10),
                          // ... autres widgets ...
                        ],
                      ),


                      // ... display selected images ...
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Alignement horizontal au centre
                        children:[ ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true; // Afficher le loader
                            });
                            if (_formKey.currentState!.validate()) {
                              String newImageUrl = "";

                              if (multiimages.isNotEmpty) {
                                newImageUrl = await uploadImageToFirebase(multiimages.first);
                              }
                              /*List<String> imageUrls = (await uploadImageToFirebase(multiimages as File)) as List<String>;
                            if (imageUrls.isEmpty) {
                              imageUrls.add(currentImageUrls.first);
                            } else {
                              currentImageUrls.removeAt(0);
                            }
                            updateEventData(imageUrls);*/


                              String? userId =
                              AuthenticationService().getCurrentUserId();
                              if (userId != null) {
                                final collectionEvenementCree = FirebaseFirestore
                                    .instance
                                    .collection('User')
                                    .doc(userId)
                                    .collection('Evenement');

                                print("id de event : ${editedEvent.id}");
                                List<String> updatedImageUrls = [...currentImageUrls];
                                if (newImageUrl.isNotEmpty) {
                                  updatedImageUrls.add(newImageUrl); // Ajouter la nouvelle URL
                                }
                                String newStatus = editedEvent.status; // Utilisez le statut actuel par défaut

                                if (editedEvent.status == 'publier') {
                                  newStatus = 'publier'; // Si le statut actuel était "publier", conservez-le
                                } // Copie des URLs existantes
                                try {
                                  await collectionEvenementCree.doc(editedEvent.id).update({
                                    'evenementName': EvenementNameController.text,
                                    'organizerName': OrganistorNameController.text,
                                    'description': descriptionController.text,
                                    'ville': selectVille,
                                    'lieu': lieuController.text,
                                    'datetime': Timestamp.fromDate(selectedDateTime!),
                                    'imageUrls': updatedImageUrls, //imageUrls,
                                    'status': newStatus,
                                    'eventId': editedEvent.id,
                                    'registeredCount': editedEvent.registeredCount,
                                    'registeredUsers': editedEvent.registeredUsers,
                                    'organizerId': userId,
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                      Text('L\'événement a été modifié avec succès !'),
                                    ),
                                  );

                                  Navigator.pop(context, true);
                                } catch (error) {
                                  print('La modification de l\'événement a échoué $error');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'La modification de l\'événement a échoué. Veuillez réessayer !'),
                                    ),
                                  );
                                }
                                finally {
                                  setState(() {
                                    _isLoading = false; // Masquer le loader
                                  });
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

                          const SizedBox(width: 12), // Espacement entre les boutons
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
                  ),
                  ],
                ),
              ),
            ),
            ), if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ]
        ),
      ),
    );
  }
}