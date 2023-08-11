import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jpope/screens/AjoutEvenement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Event.dart';
import '../services/FirebaseAuthServices.dart';
import 'DetailEvents.dart';

class PageEvenement extends StatefulWidget {
  const PageEvenement({Key? key}) : super(key: key); // Fixed typo 'super.key'

  @override
  State<PageEvenement> createState() => _PageEvenementState();
}

class _PageEvenementState extends State<PageEvenement> {
  late List<Event> events = [];

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async { // Added return type
    try {
      String userId = AuthenticationService().getCurrentUserId();

      final QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .collection('Evenement_cree')
          .get();

      List<Event> fetchedEvents = eventSnapshot.docs.map((doc) =>
          Event.fromFirestore(doc.data() as Map<String, dynamic>)).toList();

      fetchedEvents.sort((a, b) => a.date.compareTo(b.date));

      setState(() {
        events = fetchedEvents;
      });
    } catch (e) {
      print("Erreur lors de la récupération des événements : $e");
    }
  }

  Future<void> _refreshEvents() async {
    await fetchEvents();
    setState(() {}); // Removed unnecessary setState parameter
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshEvents,
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailsPage(event: events[index]),
                  ),
                );
              },
              child: Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          events[index].imageUrls.isNotEmpty
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: events[index].imageUrls[0],
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          )
                              : SizedBox.shrink(),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(events[index].evenementName),
                              SizedBox(height: 8,),
                              Text(events[index].organizerName),
                            ],
                          ),
                        ],
                      ),
                      PopupMenuButton<String>(
                        onSelected: (String result) {
                          if (result == 'Modifier') {
                            // Handle edit option here
                          } else if (result == 'Supprimer') {
                            // Handle delete option here
                          } else if (result == 'Partager') {
                            // Handle share option here
                          } else if (result == 'Publier') {
                            // Handle publish option here
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'Modifier',
                            child: ListTile(
                              leading: Icon(Icons.edit,color: Color(0xFF2196F3),),
                              title: Text('Modifier'),
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Supprimer',
                            child: ListTile(
                              leading: Icon(Icons.delete,color: Color(0xFF2196F3),),
                              title: Text('Supprimer'),
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Partager',
                            child: ListTile(
                              leading: Icon(Icons.share,color: Color(0xFF2196F3),),
                              title: Text('Partager'),
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Publier',
                            child: ListTile(
                              leading: Icon(Icons.publish,color: Color(0xFF2196F3), ),
                              title: Text('Publier'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final ajouter = await Navigator.push(
            context,
            PageRouteBuilder(pageBuilder: (_, __, ___) => AddEvent()),
          );
          if (ajouter == true) {
            fetchEvents();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}