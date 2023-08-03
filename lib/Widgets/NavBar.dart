
import 'package:flutter/material.dart';
import 'package:jpope/screens/WelcomePage.dart';
import 'package:jpope/services/FirebaseAuthServices.dart';


class NavBar extends StatelessWidget {
   const NavBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
                accountName: Text("Admin"),
                accountEmail:Text("admin@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.network(
                        'https://photos.google.com/u/1/photo/AF1QipMkyQfBFgPEfz1GrPuRMJITxuI4CTujkGJ_OIym',
                          width: 90,
                          height: 90 ,
                    ),
                  ),
                ) ,
              decoration: BoxDecoration(
                color: Colors.blueAccent
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Paramètre',
                style: TextStyle(
                  fontSize: 16
                ),
              ),
              onTap: () => null,
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(
                  'A propos',
                style: TextStyle(
                    fontSize: 16
                ),
              ),
              onTap: () => null,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person_off_rounded),
              title: Text(
                  'Se Deconnecter',
                style: TextStyle(
                    fontSize: 16
                ),
              ),
              onTap: () {
                try{
                  AuthenticationService().signOut();
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(pageBuilder: (_,__,___)=>WelcomePage())
                  );
                }
                catch(e){
                  
                }
                
              },
            )
          ],
        ),

    );
  }
}
