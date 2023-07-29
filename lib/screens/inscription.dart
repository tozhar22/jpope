import 'package:flutter/material.dart';

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
          title: Text("S'inscrire"),
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person, color: Colors.white),
              label: Text(
                "S'inscrire",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // Ajoutez ici le code à exécuter lorsque le bouton est pressé
              },
            )
          ],
        ),
        body: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50, left: 80),
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      size: 200,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Inscription()),
                      );
                    },
                  ),
                ),
                SizedBox(height: 200),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Entre Votre email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Complétez le texte";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 200),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Entre Votre email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Complétez le texte";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 200),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Entre Votre email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Complétez le texte";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Entre votre mot de passe",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return "Le mot de passe doit contenir au moins 6 caractères";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Utilisez la méthode de navigation ici
                    },
                    child: Text("S'inscrire"),
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


