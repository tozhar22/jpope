
import 'package:flutter/material.dart';
import 'package:jpope/screens/AjoutEvenement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Event.dart';
import '../services/FirebaseAuthServices.dart';
import 'DetailEvents.dart';

class PageEvenement extends StatefulWidget {
  const PageEvenement({super.key});

  @override
  State<PageEvenement> createState() => _PageEvenementState();
}

class _PageEvenementState extends State<PageEvenement> {
  // liste des evenement
  late List<Event> events = [];

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }
  // Fonction qui permet de récuper les evenement de la base de firebase
  fetchEvents() async {
    try {
      String userId = AuthenticationService().getCurrentUserId();

      final QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .collection('Evenement_cree')
          .get();

      List<Event> fetchedEvents = eventSnapshot.docs.map((doc) =>
          Event.fromFirestore(doc.data() as Map<String, dynamic>)).toList();

      // Triez les événements par date avant de les mettre à jour dans l'état
      fetchedEvents.sort((a, b) => a.date.compareTo(b.date));

      setState(() {
        events = fetchedEvents;
      });
    } catch (e) {
      print("Erreur lors de la récupération des événements : $e");
    }
  }


// Méthode pour actualiser la liste des événements
  Future<void> _refreshEvents() async {
    await fetchEvents();
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshEvents,
        child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      // Naviguez vers la page de détails de l'événement en passant l'événement sélectionné
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailsPage(event: events[index]),
                        ),
                      );
                    },
                    title: Text(events[index].evenementName),
                    subtitle: Text(events[index].organizerName),
                    // Autres détails d'affichage comme la date, la région, etc.
                  );
                },
              ),
      ),



      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final ajouter = await Navigator.push(
            context,
            PageRouteBuilder(pageBuilder: (_, __, ___) => AddEvent()),
          );
          if (ajouter == true) {
            // Actualisez la liste des événements ici
            fetchEvents();
          }
        },
        child: Icon(Icons.add),
      ), //
    );
  }
}
