import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id; // Champ pour l'identifiant unique de l'événement
  final String evenementName;
  final String organizerName;
  final String description;
  final String region;
  final Timestamp timestamp;
  final List<String> imageUrls;
  String status; // Champ pour indiquer le statut de l'événement (cree ou publie)

  Event({
    required this.id, // Ajout du champ id
    required this.evenementName,
    required this.organizerName,
    required this.description,
    required this.region,
    required this.timestamp,
    required this.imageUrls,
    required this.status, // Ajout du champ status
  });

  factory Event.fromFirestore(String id, Map<String, dynamic> data) {
    return Event(
      id: id, // Utilisation de l'identifiant passé en argument
      evenementName: data['evenementName'],
      organizerName: data['organistorName'],
      description: data['description'],
      region: data['region'],
      timestamp: data['datetime'],
      imageUrls: List<String>.from(data['imageUrls']),
      status: data['status'], // Récupération du champ status
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'evenementName': evenementName,
      'organizerName': organizerName,
      'description': description,
      'region': region,
      'timestamp': timestamp,
      'imageUrls': imageUrls,
      'status': status, // Ajout du champ status
    };
  }

  DateTime get date => timestamp.toDate();
}