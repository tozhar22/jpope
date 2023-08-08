
import 'package:flutter/material.dart';
import '../models/Event.dart';
import 'package:cached_network_image/cached_network_image.dart';
class EventDetailsPage extends StatelessWidget {
  final Event event; // Assurez-vous d'avoir une classe Event pour représenter vos événements

  const EventDetailsPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'événement'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: event.imageUrls[0],
              placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Centrer l'indicateur de chargement
              errorWidget: (context, url, error) => Icon(Icons.error), // Afficher une icône en cas d'erreur de chargement
            ),
            SizedBox(height: 16.0),
            Text(
              event.evenementName,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Text(
              'Organisé par: ${event.organizerName}',
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
            Text(
              'Date: ${event.date}',
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
            Text(
              'Région: ${event.region}',
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
            SizedBox(height: 16.0),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              event.description,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}