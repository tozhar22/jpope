// Classse evenement qui formate les donner de firebase
class Event {
  final String evenementName;
  final String organizerName;
  final String description;
  final String region;
  final DateTime date;
  final List<String> imageUrls;

  Event({
    required this.evenementName,
    required this.organizerName,
    required this.description,
    required this.region,
    required this.date,
    required this.imageUrls,
  });

  factory Event.fromFirestore(Map<String, dynamic> data) {
    return Event(
      evenementName: data['evenementName'],
      organizerName: data['organistorName'],
      description: data['description'],
      region: data['region'],
      date: DateTime.parse(data['date']),
      imageUrls: List<String>.from(data['imageUrls']),
    );
  }
}