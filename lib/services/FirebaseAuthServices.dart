// FirebaseAuthServices.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jpope/models/user.dart';

class AuthenticationService {
  // recuperation d'une instance de fibase Auth
  final _formKey = GlobalKey<FormState>(); // Ajout de la clé pour le widget Form


  final FirebaseAuth _auth = FirebaseAuth.instance;
  // conversion de notre modele AppUser en user de firebase Auth
  AppUser? _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }
  // Méthode Stream qui renvoie l'état de l'utilisateur
  Stream<AppUser?> get user {
    return _auth.authStateChanges().map((User? user) => _userFromFirebaseUser(user));
  }

  // Récupère l'id de l'utilisateur connecté
  String getCurrentUserId() {
    User? currentUser = _auth.currentUser;
    return currentUser?.uid ?? '';
  }
  // Méthode d'inscription

  Future<AppUser?> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userFromFirebaseUser(user);

    } on FirebaseAuthException catch (e) {
      // Gérer les erreurs d'authentification Firebase ici
      if (e.code == 'user-not-found') {
        _formKey.currentState?.reset();
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
      } else if (e.code == 'wrong-password' || e.code == 'invalid-email') {
        _formKey.currentState?.reset();
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
      } else if (e.code == 'network-request-failed') {
        _formKey.currentState?.reset();
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
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur d\'authentification inattendue'),
              content: Text('Une erreur inattendue s\'est produite lors de l\'authentification. Veuillez réessayer'),
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
      return null;
    } catch (e) {
      // Gérer les autres erreurs non liées à l'authentification Firebase ici
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur d\'authentification'),
            content: Text('Une erreur s\'est produite lors de l\'authentification.'),
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
      print('Erreur d\'authentification : $e');
      return null;
    }
  }

  // Méthode de connexion
  Future<AppUser?> registerWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }
    on FirebaseAuthException catch (e) {
      // Gérer les erreurs d'authentification Firebase ici
      if (e.code == 'user-not-found') {
        _formKey.currentState?.reset();
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
      } else if (e.code == 'invalid-email') {
        _formKey.currentState?.reset();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('email invalide'),
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
      } else if (e.code == 'email-already-in-use') {
        _formKey.currentState?.reset();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('email invalide'),
              content: Text('Cet adresse email est déja utilisé par un autre compte'),
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
      else if (e.code == 'network-request-failed') {
        _formKey.currentState?.reset();
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
      return null;
    } catch (e) {
      // Gérer les autres erreurs non liées à l'authentification Firebase ici
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur d\'authentification'),
            content: Text('Une erreur s\'est produite lors de l\'inscription.'),
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
      print('Erreur d\'authentification : $e');
      return null;
    }

  }


// Méthode de deconnexion
Future<void> signOut() async {
  try {
        await _auth.signOut();
  }     catch (exception) {
              print(exception.toString());
        }
      }
}