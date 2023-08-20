import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String evenementName;
  final String organizerId; // Champ pour l'ID de l'utilisateur créateur
  final String organizerName;
  final String description;
  final String ville;
  final String lieu;
  final Timestamp timestamp;
  final List<String> imageUrls;
  String status;
  int registeredCount;
  List<String> registeredUsers;

  Event({
    required this.id,
    required this.evenementName,
    required this.organizerId,
    required this.organizerName,
    required this.description,
    required this.ville,
    required this.lieu,
    required this.timestamp,
    required this.imageUrls,
    required this.status,
    required this.registeredCount,
    required this.registeredUsers,
  });

  factory Event.fromFirestore(String id, Map<String, dynamic> data) {
    return Event(
      id: id,
      evenementName: data['evenementName'],
      organizerId: data.containsKey('organizerId') ? data['organizerId'] as String : '',
      organizerName: data.containsKey('organistorName') ? data['organistorName'] as String : '',
      description: data.containsKey('description') ? data['description'] as String : '',
      ville: data.containsKey('ville') ? data['ville'] as String : '',
      lieu: data.containsKey('lieu') ? data['lieu'] as String : '',
      timestamp: data.containsKey('datetime') ? data['datetime'] as Timestamp : Timestamp.now(),
      imageUrls: data.containsKey('imageUrls') ? List<String>.from(data['imageUrls']) : [],
      status: data.containsKey('status') ? data['status'] as String : '',
      registeredCount: data.containsKey('registeredCount') ? data['registeredCount'] as int : 0,
      registeredUsers: data.containsKey('registeredUsers') ? List<String>.from(data['registeredUsers']) : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'evenementName': evenementName,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'description': description,
      'ville': ville,
      'lieu': lieu,
      'timestamp': timestamp,
      'imageUrls': imageUrls,
      'status': status,
      'registeredCount': registeredCount,
      'registeredUsers': registeredUsers,
    };
  }

  DateTime get date => timestamp.toDate();
}