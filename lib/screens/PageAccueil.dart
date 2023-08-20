import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Event.dart';
import '../services/FirebaseAuthServices.dart';
import 'Plus informations.dart';


class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  late List<Event> publishedEvents = [];
  bool isLoading = true;

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

        List<Event> userPublishedEvents = eventSnapshot.docs
            .map((doc) => Event.fromFirestore(
            doc.id, doc.data() as Map<String, dynamic>))
            .toList();

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

      // Ajout des informations de l'événement à la sous-collection de l'utilisateur inscrit
      DocumentReference userEventRef = FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .collection('EvenementsInscrits')
          .doc(event.id);

      await userEventRef.set({
        'evenementName': event.evenementName,
        'organizerName': event.organizerName,
        'imageUrls': event.imageUrls,
        'description': event.description,
        'ville': event.ville,
        'lieu': event.lieu,
        'datetime': event.timestamp,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inscription réussie')),
      );
    } catch (e) {
      print("Erreur lors de l'inscription à l'événement : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'inscription')),
      );
    }
  }
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
    } catch (e) {
      print("Erreur lors de la désinscription à l'événement : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la désinscription')),
      );
    }
  }

  Widget buildEventCard(Event event) {
    return Card(
      margin: EdgeInsets.all(8),
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
                  showDialog(
                    context: context,
                    builder: (context) => MoreInfoDialog(event: event),
                  );
                },
                child: Text('Plus d\'informations'),
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
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshEvents,
        child: isLoading // Vérifier l'état de chargement
            ?Center(
              child: CircularProgressIndicator(), // Afficher le loader
            )
            : ListView.builder(
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
      ),
    );
  }
}