import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Event.dart';
import '../models/UserFireStore.dart';

class EventDetailsForPeople extends StatelessWidget {
  final Event event;

  const EventDetailsForPeople({required this.event});

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
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(height: 16.0),
              Text(
                event.evenementName,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    'Organisé par: ${event.organizerName}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    'Date: ${event.date}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(
                    Icons.location_city,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    'Ville: ${event.ville}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(
                    Icons.place,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    'Lieu: ${event.lieu}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                'Description:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                event.description,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
