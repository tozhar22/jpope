import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jpope/screens/EditEvent.dart';
import 'package:jpope/screens/EventDetailsForAllPeople.dart';
import '../models/Event.dart';
import '../services/FirebaseAuthServices.dart';



class Accueil extends StatefulWidget {
  final bool isAdmin;
  const Accueil({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> with AutomaticKeepAliveClientMixin{
  late List<Event> publishedEvents = [];
  bool isLoading = true;
  bool get wantKeepAlive => true;
  List<String> userIDs = [];
  bool isProcessingAction = false;
  @override
  void initState() {
    super.initState();
    fetchAllPublishedEvents();
  }

  Future<void> fetchAllPublishedEvents() async {
    try {
      QuerySnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('User').get();

      List<Event> allPublishedEvents = [];

      for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
        QuerySnapshot eventSnapshot = await userDoc.reference
            .collection('Evenement')
            .where('status', isEqualTo: 'Publier')
            .get();

        List<Event> userPublishedEvents = eventSnapshot.docs.map((doc) {
          return Event.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
        }).toList();

        allPublishedEvents.addAll(userPublishedEvents);
      }

      allPublishedEvents.sort((a, b) => a.date.compareTo(b.date));

      setState(() {
        publishedEvents = allPublishedEvents;
        isLoading = false; // Mettre à jour l'état pour cacher le loader
      });
    } catch (e) {
      print("Erreur lors de la récupération des événements publiés : $e");
      setState(() {
        isLoading = false; // Gérer l'état du loader même en cas d'erreur
      });
    }
  }
  // Méthode pour l'inscription

  void _EventInscription(Event event) async {
    try {
      String userId = AuthenticationService().getCurrentUserId();

      // vérification si l'utilisateur c'est dédja inscrit à l'évènement

      bool isAlreadyRegistered = event.registeredUsers.contains(userId);

      if (isAlreadyRegistered) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vous êtes déjà inscrit à cet événement')),
        );
        return;
      }

      // Mettre à jour les champs registeredCount et registeredUsers de l'événement
      DocumentReference eventRef = FirebaseFirestore.instance
          .collection('User')
          .doc(event.organizerId)
          .collection('Evenement')
          .doc(event.id);

      await eventRef.update({
        'registeredCount': FieldValue.increment(1),
      });

      // Ajouter l'utilisateur à la liste des inscrits
      await eventRef.update({
        'registeredUsers': FieldValue.arrayUnion([userId]),
      });
      // Génération du QR Code
      String qrData = "$userId|${event.id}|${event.evenementName}|${event.organizerName}";
      // Ajout des informations de l'événement à la sous-collection de l'utilisateur inscrit
      DocumentReference userEventRef = FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .collection('EvenementsInscrits')
          .doc(event.id);

      await userEventRef.set({
        'evenementName': event.evenementName,
        'organizerName': event.organizerName,
        'organizerId': event.organizerId,
        'eventId': event.id,
        'imageUrls': event.imageUrls,
        'description': event.description,
        'ville': event.ville,
        'lieu': event.lieu,
        'datetime': event.timestamp,
        'qrData': qrData,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inscription réussie')),
      );
      await _refreshEvents();
    } catch (e) {
      print("Erreur lors de l'inscription à l'événement : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'inscription')),
      );
    }
  }
  // La desinscription sur cette page se base sur la liste event dans l'application
  void _EventDesinscription(Event event) async {
    try {
      String userId = AuthenticationService().getCurrentUserId();

      // Vérification si l'utilisateur est inscrit à l'évènement
      bool isRegistered = event.registeredUsers.contains(userId);

      if (!isRegistered) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vous n\'êtes pas inscrit à cet événement')),
        );
        return;
      }

      // Mettre à jour les champs registeredCount et registeredUsers de l'événement
      DocumentReference eventRef = FirebaseFirestore.instance
          .collection('User')
          .doc(event.organizerId)
          .collection('Evenement')
          .doc(event.id);

      await eventRef.update({
        'registeredCount': FieldValue.increment(-1),
      });

      // Retirer l'utilisateur de la liste des inscrits
      await eventRef.update({
        'registeredUsers': FieldValue.arrayRemove([userId]),
      });

      // Suppression des informations de l'événement de la sous-collection de l'utilisateur inscrit
      DocumentReference userEventRef = FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .collection('EvenementsInscrits')
          .doc(event.id);

      await userEventRef.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Désinscription réussie')),
      );
      await _refreshEvents();
    } catch (e) {
      print("Erreur lors de la désinscription à l'événement : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la désinscription')),
      );
    }
  }
  // Méthode de déplublication pour admin

  Future<void> _depublishEvent(Event event) async {
    try {
      setState(() {
        isProcessingAction = true;
      });

      // Set the status of the event to 'Non publié'
      await FirebaseFirestore.instance
          .collection('User')
          .doc(event.organizerId)
          .collection('Evenement')
          .doc(event.id)
          .update({'status': 'cree'});

      // Refresh the events
      await _refreshEvents();
    } catch (e) {
      print('Erreur lors de la dépublication de l\'événement : $e');
    } finally {
      setState(() {
        isProcessingAction = false;
      });
    }
  }
  // Méthode de suppression evenement pour admin

  Future<void> _deleteEvent(Event event) async {
    try {
      setState(() {
        isProcessingAction = true;
      });

      // Delete the event document
      await FirebaseFirestore.instance
          .collection('User')
          .doc(event.organizerId)
          .collection('Evenement')
          .doc(event.id)
          .delete();

      // Refresh the events
      await _refreshEvents();
    } catch (e) {
      print('Erreur lors de la suppression de l\'événement : $e');
    } finally {
      setState(() {
        isProcessingAction = false;
      });
    }
  }
  Widget buildEventCard(Event event) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/images/profile-user.png'),
              ),
            ),
            title: Text(event.evenementName),
            subtitle: Text(event.organizerName),
          ),
          Container(
            width: double.infinity,
            child: Image.network(
              event.imageUrls[0],
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (event.registeredUsers.contains(
                      AuthenticationService().getCurrentUserId())) {
                    _EventDesinscription(event);
                  } else {
                    _EventInscription(event);
                  }
                },
                child: Text(
                  event.registeredUsers.contains(
                      AuthenticationService().getCurrentUserId())
                      ? 'Se désinscrire'
                      : 'S\'inscrire',
                ),
              ),
              TextButton(
                onPressed: () {
                  /*
                  showDialog(
                    context: context,
                    builder: (context) => MoreInfoDialog(event: event),
                  );
                  */
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>EventDetailsForPeople(event: event,)),
                  );
                },
                child: Text('Plus d\'informations'),
              ),
              SizedBox(width: 15,),
              if (widget.isAdmin)
                PopupMenuButton<String>(
                  icon: Icon(Icons.arrow_drop_down, color: Color(0xFF2196F3)),
                  onSelected: (String result) {
                    // Handle the selected menu option
                    if (result == 'Modifier') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditEvent(event: event),
                        ),
                      );
                    } else if (result == 'Supprimer') {
                      _deleteEvent(event);
                    }
                    else if (result == 'Depublier'){
                      _depublishEvent(event);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'Modifier',
                        child: ListTile(
                          leading: Icon(Icons.edit, color: Color(0xFF2196F3)),
                          title: Text('Modifier'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Depublier',
                        child: ListTile(
                          leading: Icon( Icons.cancel, color: Colors.red),
                          title: Text('Depublier'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Supprimer',
                        child: ListTile(
                          leading: Icon(Icons.delete, color:Colors.red),
                          title: Text('Supprimer'),
                        ),
                      ),
                    ];
                  },
                ),

            ],
          ),
        ],
      ),
    );
  }

  Future<void> _refreshEvents() async {
    await fetchAllPublishedEvents();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshEvents,
        child: Stack(
          children: [
            ListView.builder(
              itemCount: publishedEvents.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Naviguer vers la page de détails de l'événement ici si nécessaire
                  },
                  child: buildEventCard(publishedEvents[index]),
                );
              },
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(), // Afficher le loader
              ),
            if (isProcessingAction)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }}