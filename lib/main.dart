import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jpope/models/user.dart';
import 'package:jpope/services/FirebaseAuthServices.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'models/SplashScreenWrapper.dart';


void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
        // Utilisez un Builder pour s'assurer que le StreamProvider est initialisé
    Builder(
      builder: (context) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: AuthenticationService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mon App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // Autres configurations de thème possibles
        ),
        home: const SplashScreenWrapper(),
      ),
    );
  }
}