// FirebaseAuthServices.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jpope/models/user.dart';

class AuthenticationService {
  // recuperation d'une instance de fibase Auth

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // conversion de notre modele AppUser en user de firebase Auth
  AppUser? _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }
  // Méthode Stream qui renvoie l'état de l'utilisateur
  Stream<AppUser?> get user {
    return _auth.authStateChanges().map((User? user) => _userFromFirebaseUser(user));
  }
  // Méthode d'inscription

  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }
  // Méthode de connexion
  Future<AppUser?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }
  // Méthode de deconnexion
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (exception) {
      print(exception.toString());
    }
  }
}
