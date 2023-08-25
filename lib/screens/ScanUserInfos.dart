import 'package:flutter/material.dart';

import '../models/UserFireStore.dart';

class ScannedUserInfoPage extends StatelessWidget {
  final UserInfo? user;

  const ScannedUserInfoPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'utilisateur'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/profile-user.png', // Remplacez par le chemin d'accès à votre image
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            if (user != null) // Vérifier si user n'est pas nul
              Column(
                children: [
                  Text(
                    user?.username ?? 'Nom d\'utilisateur inconnu', // Utiliser le conditionnel null ici
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user?.email ?? 'Email inconnu', // Utiliser le conditionnel null ici
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            if (user == null) // Si user est nul
              Text(
                'Utilisateur introuvable',
                style: TextStyle(fontSize: 20),
              ),
          ],
        ),
      ),
    );
  }
}