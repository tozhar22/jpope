import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../models/UserFireStore.dart';
import 'ScanUserInfos.dart';

class RegisteredUsersListPage extends StatefulWidget {
  final List<UserInfo> userInfoList;

  const RegisteredUsersListPage({required this.userInfoList});

  @override
  State<RegisteredUsersListPage> createState() => _RegisteredUsersListPageState();
}

class _RegisteredUsersListPageState extends State<RegisteredUsersListPage> {
  String _scannedCode = 'Aucun code scanné';
  Future<void> _scanAndDisplayUserInfo() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Annuler',
      true,
      ScanMode.QR,
    );

    if (!mounted) return;

    List<String> scanParts = barcodeScanRes.split('|');
    String scannedUserId = scanParts[0];

    UserInfo? scannedUser;
    for (UserInfo user in widget.userInfoList) {
      if (user.userId == scannedUserId) {
        scannedUser = user;
        break;
      }
    }

    if (scannedUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScannedUserInfoPage(user: scannedUser),
        ),
      );
    } else {
      // Afficher un message si l'utilisateur n'est pas trouvé
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Utilisateur introuvable'),
            content: const Text('Aucun utilisateur correspondant à cet ID.'),
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
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des personnes inscrites'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.qr_code_scanner,
              color: Colors.white,
            ),
            onPressed: () {
              _scanAndDisplayUserInfo();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: widget.userInfoList.length,
          itemBuilder: (context, index) {
            UserInfo userInfo = widget.userInfoList[index];

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