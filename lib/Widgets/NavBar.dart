
import 'package:flutter/material.dart';

import 'package:jpope/screens/WelcomePage.dart';
import 'package:jpope/services/FirebaseAuthServices.dart';

class NavBar extends StatelessWidget {
  final String name;
  final String email;
  final bool isAdmin;
  const NavBar({Key? key, required this.name, required this.email, required this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/images/profile-user.png'),
              ),
            ),
            decoration: BoxDecoration(color: Colors.blueAccent),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Paramètre',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () => null,
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(
              'A propos',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () => null,
          ),
          if (isAdmin) // Add the admin-specific option if isAdmin is true
            ListTile(
              leading: Icon(Icons.admin_panel_settings),
              title: Text(
                'Admin Actions',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                // Handle admin-specific action
              },
            ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person_off_rounded),
            title: Text(
              'Se Deconnecter',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              try {
                AuthenticationService().signOut();
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(pageBuilder: (_, __, ___) => WelcomePage()),
                );
              } catch (e) {}
            },
          )

        ],
      ),
    );
  }
}