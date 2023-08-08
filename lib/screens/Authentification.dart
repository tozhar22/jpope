
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jpope/screens/inscription.dart';

import '../models/user.dart';
import '../services/FirebaseAuthServices.dart';
import 'ApplicationInterface.dart';

class Authentification extends StatefulWidget {
  const Authentification({Key? key}) : super(key: key);

  @override
  State<Authentification> createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  final AuthenticationService _auth = AuthenticationService();
  final _formKey = GlobalKey<FormState>(); // Ajout de la clé pour le widget Form
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
    Future.delayed(Duration(milliseconds: 8), () {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 110, bottom: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/images/log.png',
                    height: 150,
                    width: 150,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Se connecter",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.all(20),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Entre Votre email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Complétez le champs";
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
                        String email = emailController.text;
                        String password = passwordController.text;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Connexion en cours...")),
                        );
                        try {
                          AppUser? result = await _auth.signInWithEmailAndPassword(context, email, password);
                          if (result != null) {

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ApplicationInterface()), // Remplacez 'HomePage' par le nom de votre page
                            );
                            final alertDialogKey = GlobalKey<State>();

                            showDialog (
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  title: Text('Connexion réussie'),
                                  content: Text('Vous êtes maintenant connecté.'),
                                );
                              },
                            ).then((_) {
                              // Ferme automatiquement la boîte de dialogue après 1 seconde.
                              Future.delayed(Duration(seconds: 1), () async{
                                Navigator.of(context).pop(); // Ferme automatiquement la boîte de dialogue.
                              });
                            });
                          }

                        }catch (e) {
                          print('Erreur d\'authentification : $e');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0), // Ajuster la valeur du rayon selon vos préférences
                      ),
                    ),
                    child: Text("SE CONNECTER"),
                  ),
                ),
              ),
              Text("Vous n'avez pas de compte ?"),
              SizedBox(height:8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Inscription()),
                  );
                },
                child: Text(
                  "S'INSCRIRE",
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

