
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
  bool _obscurePassword = true; // Par défaut, le mot de passe est masqué





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
                    height: 140,
                    width: 140,
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
                  onChanged: (value) {
                    // Supprimez les espaces au début et à la fin de l'entrée
                    emailController.text = value.trim();
                    emailController.selection = TextSelection.fromPosition(
                      TextPosition(offset: emailController.text.length),
                    );
                  },
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
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          // Inversez la visibilité du mot de passe
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: _obscurePassword ? Colors.grey : Colors.blue,
                      ),
                    ),
                  ),
                  obscureText: _obscurePassword, // Utilisez cette variable pour déterminer si le mot de passe doit être masqué ou non
                  onChanged: (value) {
                    // Pas besoin de supprimer les espaces des mots de passe
                  },
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

                            showDialog (
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  title: Text('Connexion réussie'),
                                  content: Text('Vous êtes maintenant connecté.'),
                                  );
                                },
                              );

                            await Future.delayed(const Duration(seconds: 1));
                            Navigator.of(context).pop();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ApplicationInterface()), // Remplacez 'HomePage' par le nom de votre page
                            );


                            final alertDialogKey = GlobalKey<State>();
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

