import 'package:flutter/material.dart';

import '../models/UserFireStore.dart';

class RegisteredUsersListPage extends StatelessWidget {
  final List<UserInfo> userInfoList;

  const RegisteredUsersListPage({required this.userInfoList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des personnes inscrites'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: userInfoList.length,
          itemBuilder: (context, index) {
            UserInfo userInfo = userInfoList[index];

            return Card(
              child: ListTile(
                leading: const Icon(Icons.account_circle),
                title: Text(userInfo.username),
                subtitle: Text(userInfo.email),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Informations utilisateur'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Nom d\'utilisateur: ${userInfo.username}'),
                            Text('E-mail: ${userInfo.email}'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Fermer'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}