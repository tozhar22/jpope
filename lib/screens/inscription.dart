import 'package:flutter/material.dart';

import 'Authentification.dart';

class Inscription extends StatefulWidget {
  const Inscription({Key? key}) : super(key: key);

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Inscription"),
        ),
        body: Form(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset('assets/images/lg.png',
                    height: 200, width: 200,
                    ),
                ),
                Center(
                  child: Text("Créer un compte",
                  style: TextStyle(
                    fontSize: 25,
                  ),),
                ),

                SizedBox(height: 50),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_3),
                    hintText: "Nom d'utilisateur",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),

                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Complétez le texte";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Entre Votre email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Complétez le texte";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5), // Couleur de l'ombre
                        spreadRadius: 5, // Augmenter cette valeur pour déplacer l'ombre vers l'extérieur
                        blurRadius: 5, // Flou de l'ombre
                        offset: Offset(0, 5), // Décalage de l'ombre (horizontal, vertical)
                      ),
                    ],
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: TextFormField(
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


                SizedBox(height: 30),
                SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Utilisez la méthode de navigation ici
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0), // Ajuster la valeur du rayon selon vos préférences
                      ),

                    ),
                    child: Text("S'inscrire"),
                  ),
                ),
                Text("Vous avez un compte ? ",),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Authentification()),
                    );
                  },
                    child: Text(
                    'Se connecter',
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
      ),
    );
  }
}


