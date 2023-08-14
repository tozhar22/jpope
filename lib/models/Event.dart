import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String evenementName;
  final String organizerName;
  final String description;
  final String region;
  final Timestamp timestamp; // Utilisez le type Timestamp pour stocker le timestamp
  final List<String> imageUrls;

  Event({
    required this.evenementName,
    required this.organizerName,
    required this.description,
    required this.region,
    required this.timestamp, // Mettez à jour ici
    required this.imageUrls,
  });

  factory Event.fromFirestore(Map<String, dynamic> data) {
    return Event(
      evenementName: data['evenementName'],
      organizerName: data['organistorName'],
      description: data['description'],
      region: data['region'],
      timestamp: data['datetime'], // Assurez-vous d'utiliser le bon nom de champ
      imageUrls: List<String>.from(data['imageUrls']),
    );
  }

  DateTime get date => timestamp.toDate(); // Méthode pour obtenir la date à partir du timestamp
}