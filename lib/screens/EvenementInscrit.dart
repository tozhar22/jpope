import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jpope/screens/DetailsEvenementsInscrit.dart';
import '../models/Event.dart';
import '../services/FirebaseAuthServices.dart';
import 'DetailEvents.dart';

class Agenda extends StatefulWidget {
  const Agenda({Key? key}) : super(key: key);

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  late List<Event> events = [];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      String userId = AuthenticationService().getCurrentUserId();

      final QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .collection('EvenementsInscrits')
          .get();

      List<Event> fetchedEvents = eventSnapshot.docs.map((doc) =>
          Event.fromFirestore(doc.id, doc.data() as Map<String, dynamic>)).toList();

      fetchedEvents.sort((a, b) => a.date.compareTo(b.date));

      setState(() {
        events = fetchedEvents;
      });

      print(events[1].organizerName+'rien');
    } catch (e) {
      print("Erreur lors de la récupération des événements : $e");
    }
  }

  Future<void> _refreshEvents() async {
    await fetchEvents();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshEvents,
        child: Stack(
            children: [RefreshIndicator(
              onRefresh: _refreshEvents,
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsEventInscrit(event: events[index]),
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
                                    const SizedBox(height: 8,),
                                    Text(events[index].organizerName),
                                  ],
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
              if (_isLoading)
                Container(
                  color: Colors.black12.withOpacity(0.8), // Couleur de fond semi-transparente
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ]
        ),
      ),
    );
  }
}