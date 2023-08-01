import 'package:flutter/cupertino.dart';
import 'package:jpope/models/user.dart';
import 'package:jpope/screens/ApplicationInterface.dart';

import 'package:jpope/screens/WelcomePage.dart';

import 'package:provider/provider.dart';

class SplashScreenWrapper extends StatelessWidget {
  const SplashScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    if (user == null) {
      return WelcomePage();
    } else {
      return ApplicationInterface();
    }
  }
}
