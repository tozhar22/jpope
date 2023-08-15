import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jpope/screens/AjoutEvenement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Event.dart';
import '../services/FirebaseAuthServices.dart';
import 'DetailEvents.dart';

class PageEvenement extends StatefulWidget {
  const PageEvenement({Key? key}) : super(key: key);

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

  Future<void> fetchEvents() async {
    try {
      String userId = AuthenticationService().getCurrentUserId();

      final QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .collection('Evenement')
          .get();

      List<Event> fetchedEvents = eventSnapshot.docs.map((doc) =>
          Event.fromFirestore(doc.id, doc.data() as Map<String, dynamic>)).toList();

      fetchedEvents.sort((a, b) => a.date.compareTo(b.date));

      setState(() {
        events = fetchedEvents;
      });
    } catch (e) {
      print("Erreur lors de la récupération des événements : $e");
    }
  }

  Future<void> publishEvent(Event event) async {
    try {
      String userId = AuthenticationService().getCurrentUserId();

      await FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .collection('Evenement')
          .doc(event.id)
          .update({'status': 'Publier'});

      setState(() {
        event.status = 'Publier';
      });

      print('Événement publié avec succès.');
    } catch (e) {
      print('Erreur lors de la publication de l\'événement : $e');
    }
  }

  Future<void> unpublishEvent(Event event) async {
    try {
      String userId = AuthenticationService().getCurrentUserId();

      await FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .collection('Evenement')
          .doc(event.id)
          .update({'status': 'cree'});

      setState(() {
        event.status = 'cree';
      });

      print('Événement dépublié avec succès.');
    } catch (e) {
      print('Erreur lors de la dépuplication de l\'événement : $e');
    }
  }
  Future<void> deleteEvent(Event event) async {
    try {
      String userId = AuthenticationService().getCurrentUserId();

      await FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .collection('Evenement')
          .doc(event.id)
          .delete();

      setState(() {
        events.remove(event);
      });

      print('Événement supprimé avec succès.');
    } catch (e) {
      print('Erreur lors de la suppression de l\'événement : $e');
    }
  }
  Future<void> confirmDelete(Event event) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Supprimer l'événement"),
          content: Text("Êtes-vous sûr de vouloir supprimer cet événement ?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                await deleteEvent(event);
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: Text("Supprimer"),
            ),
          ],
        );
      },
    );
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
                        onSelected: (String result) async {
                          if (result == 'Modifier') {
                            // Handle edit option here
                          } else if (result == 'Supprimer') {
                            confirmDelete(events[index]);
                          } else if (result == 'Partager') {
                            // Handle share option here
                          } else if (result == 'Publier') {
                            await publishEvent(events[index]);
                          } else if (result == 'Dépublier') {
                            await unpublishEvent(events[index]);
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          List<PopupMenuEntry<String>> menuItems = [];
                          menuItems.add(
                            const PopupMenuItem<String>(
                              value: 'Modifier',
                              child: ListTile(
                                leading: Icon(Icons.edit, color: Color(0xFF2196F3)),
                                title: Text('Modifier'),
                              ),
                            ),
                          );
                          menuItems.add(
                            const PopupMenuItem<String>(
                              value: 'Supprimer',
                              child: ListTile(
                                leading: Icon(Icons.delete, color: Color(0xFF2196F3)),
                                title: Text('Supprimer'),
                              ),
                            ),
                          );
                          menuItems.add(
                            const PopupMenuItem<String>(
                              value: 'Partager',
                              child: ListTile(
                                leading: Icon(Icons.share, color: Color(0xFF2196F3)),
                                title: Text('Partager'),
                              ),
                            ),
                          );

                          if (events[index].status == 'cree') {
                            menuItems.add(
                              const PopupMenuItem<String>(
                                value: 'Publier',
                                child: ListTile(
                                  leading: Icon(Icons.publish, color: Color(0xFF2196F3)),
                                  title: Text('Publier'),
                                ),
                              ),
                            );
                          } else if (events[index].status == 'Publier') {
                            menuItems.add(
                              const PopupMenuItem<String>(
                                value: 'Dépublier',
                                child: ListTile(
                                  leading: Icon(Icons.cancel, color: Colors.red),
                                  title: Text('Dépublier'),
                                ),
                              ),
                            );
                          }
                          return menuItems;
                        },
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