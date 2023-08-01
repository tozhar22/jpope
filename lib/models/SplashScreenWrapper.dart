import 'package:flutter/cupertino.dart';
import 'package:jpope/models/user.dart';
import 'package:jpope/screens/ApplicationInterface.dart';
import 'package:jpope/screens/inscription.dart';
import 'package:provider/provider.dart';

class SplashScreenWrapper extends StatelessWidget {
  const SplashScreenWrapper({Key? key}) : super(key: key); // Utilisez 'Key?' au lieu de 'super.key'

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context); // Utilisez 'AppUser?' au lieu de 'AppUser'

    if (user == null) {
      return Inscription();
    } else {
      return ApplicationInterface();
    }
  }
}
