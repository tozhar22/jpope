import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Event.dart';
import '../models/UserFireStore.dart';
import 'ListePersonneInscrit.dart';


class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'événement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: event.imageUrls[0],
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(height: 16.0),
              Text(
                event.evenementName,
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'Organisé par: ${event.organizerName}',
                style: const TextStyle(fontSize: 18.0, color: Colors.grey),
              ),
              Text(
                'Date: ${event.date}',
                style: const TextStyle(fontSize: 18.0, color: Colors.grey),
              ),
              Text(
                'ville: ${event.ville}',
                style: const TextStyle(fontSize: 18.0, color: Colors.grey),
              ),
              Text(
                'Lieu: ${event.lieu}',
                style: const TextStyle(fontSize: 18.0, color: Colors.grey),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Description:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Text(
                event.description,
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Nombre de personnes inscrites: ${event.registeredCount}',
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text('Liste des personnes inscrites'),
                  onTap: () async {
                    List<UserInfo> userInfoList = await fetchUserInfo(event.registeredUsers);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisteredUsersListPage(userInfoList: userInfoList),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<UserInfo>> fetchUserInfo(List<String> userIds) async {
    List<UserInfo> userInfos = [];

    for (String userId in userIds) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .get();

      String username = userSnapshot['userName'];
      String email = userSnapshot['mail'];

      userInfos.add(UserInfo(userId: userId, username: username, email: email));
    }

    return userInfos;
  }
}
