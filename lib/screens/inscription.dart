import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jpope/screens/ApplicationInterface.dart';
import 'package:jpope/services/FirebaseAuthServices.dart';

import '../models/user.dart';
import 'Authentification.dart';




class Inscription extends StatefulWidget {
  const Inscription({Key? key}) : super(key: key);
  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {

  final AuthenticationService _auth = AuthenticationService();

  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Connexion réussie'),
          content: Text('Félicitations ! Votre connexion s\'est bien déroulée.'),
        );
      },
    ).then((_) {
      // Ferme automatiquement la boîte de dialogue après 1 seconde.
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pop(); // Ferme automatiquement la boîte de dialogue.
      });
    });
  }

  _showUserNotFound(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Compte introuvable'),
          content: Text('Aucun compte n\'est associé à cet e-mail. Veuillez vous inscrire avant de vous connecter.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
  _showNetworkError(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Problème de connexion'),
          content: Text('Pas de connexion.Veuillez réessayer plus tard'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
  _showErroDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Identifiants incorrects'),
          content: Text('Nom d’utilisateur ou mot de passe incorrect'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(

          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 60),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/images/log.png',
                    height: 150,
                    width: 150,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  "Créer un compte",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_3),
                    hintText: "Nom d'utilisateur",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Complétez le texte";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: "Entre Votre email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Complétez le texte";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Entre votre mot de passe",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return "Le mot de passe doit contenir au moins 6 caractères";
                    }
                    return null;
                  },
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 25, bottom: 10),
                child: SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {

                      if (_formKey.currentState!.validate()) {

                        String userName = userNameController.text;
                        String email = emailController.text;
                        String password = passwordController.text;


                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Inscription en cours...")),
                        );

                        // Appelle de la méthode d'inscription depuis la class d'authentification

                          try {

                            AppUser? result = await _auth.registerWithEmailAndPassword(context, email, password);

                          if (result != null) {
                            // L'inscription a réussi, vous pouvez effectuer des actions supplémentaires ici
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Inscription réussie !")),
                            );

                            String userId = result.uid;

                            CollectionReference userRef = FirebaseFirestore.instance.collection("User");
                            userRef.doc(userId).set({ // Utiliser l'ID de l'utilisateur comme ID du document dans Firestore
                              'mail': email,
                              'userName': userName,
                              'password' : password,
                              'URL_image' : null
                            });

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ApplicationInterface()), // Remplacez 'HomePage' par le nom de votre page
                            );
                            showDialog (
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  title: Text('Inscription réussie'),
                                  content: Text('Vous êtes maintenant inscrit.'),
                                );
                              },
                            );

                          }
                        } catch (e) {
                          print('Erreur d\'authentification : $e');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0), // Ajuster la valeur du rayon selon vos préférences
                      ),
                    ),
                    child: Text("S'INSCRIRE"),
                  ),

                ),
              ),
              Text("Vous avez un compte ?"),
              SizedBox(height:8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Authentification()),
                  );
                },
                child: Text(
                  'SE CONNECTER',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}