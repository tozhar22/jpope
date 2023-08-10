
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jpope/services/FirebaseAuthServices.dart';


class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {

  final _formKey = GlobalKey<FormState>();
  final EvenementNameController = TextEditingController();
  final OrganistorNameController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime selectDate = DateTime.now();
  String selectRegion = 'region maritime';



  final ImagePicker _imagePicker = ImagePicker();
  List<File> multiimages =[];

  multiImagePicker()async{
    final List<XFile> pickedImage = await _imagePicker.pickMultiImage();
    pickedImage.forEach((e) {
      multiimages.add(File(e.path));
    }
    );
    setState(() {

    });
  }
  // Méthode pour enregister les images
  Future<List<String>> uploadImagesToFirebase(List<File> images) async {
    List<String> imageUrls = [];

    for (var image in images) {
      // Create a unique filename for each image
      String filename = DateTime.now().millisecondsSinceEpoch.toString();

      // Reference to the image in Firebase Storage
      Reference storageReference =
      FirebaseStorage.instance.ref().child('event_images/$filename.jpg');

      // Upload the image to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask;

      // Get the download URL of the uploaded image
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
  void initState() {
    super.initState();
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
                          labelText: "Non de l'Evènement",
                          hintText: "Saisir le nom de l'Evenement",
                          border: OutlineInputBorder()
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ("Vous devez completer ce champ");
                        }
                        return null;
                      },
                      controller: EvenementNameController
                  ),
                  const SizedBox(height: 25,),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Organisateur",
                        hintText: "Saisir le nom de l'organisteur",
                        border: OutlineInputBorder()
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ("Tu dois completer ce champ");
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
                        return "Tu dois compléter ce champ";
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
                            value: 'region des Plateux', child: Text("Plateaux")),
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
                  DateTimeFormField(
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.black45),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: 'Choisir une date',
                    ),
                    mode: DateTimeFieldPickerMode.dateAndTime,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (e) =>
                    (e?.day ?? 0) == 1
                        ? 'Please not the first day'
                        : null,
                    onDateSelected: (DateTime value) {
                      setState(() {
                        selectDate = value;
                      });
                    },
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
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                          onPressed: () async {
                              if(_formKey.currentState!.validate()){

                                // envoiyer l'image sur firebase Storage

                                  List<String> imageUrls = await uploadImagesToFirebase(multiimages);

                                // Ajouter les donnée de l'evenement sur fireStore

                                  final DonneEvenement = {
                                    'evenementName': EvenementNameController.text,
                                    'organistorName': OrganistorNameController.text,
                                    'description': descriptionController.text,
                                    'region': selectRegion,
                                    'date': selectDate.toIso8601String(),
                                    'imageUrls': imageUrls,
                                  };

                                // Obtenir l'ID de l'utilisateur actuel

                                  String? userId = AuthenticationService().getCurrentUserId();

                                  // Référence à la sous-collection 'Evenement_cree' du document de l'utilisateur
                                final collectionEvementCree = FirebaseFirestore.instance.collection('User').doc(userId).collection('Evenement_cree');
                                try{
                                  await collectionEvementCree.add(DonneEvenement);

                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('L\'événement a été ajouté avec succès !'),
                                  ));
                                  Navigator.pop(context, true);
                                }
                                catch(e){

                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('Une erreur s\'est produite lors de l\'ajout de l\'événement.'),
                                  ));
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
