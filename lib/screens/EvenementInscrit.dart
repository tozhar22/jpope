
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jpope/screens/DetailsEvenementsInscrit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import '../models/Event.dart';
import '../services/FirebaseAuthServices.dart';

class Agenda extends StatefulWidget {
  const Agenda({Key? key}) : super(key: key);

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  late List<Event> events = [];
  List<Event> filteredEvents = [];
  bool _isLoading = false;
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

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

    } catch (e) {
      print("Erreur lors de la récupération des événements : $e");
    }
  }
  Future<void> shareEvent(Event event) async {
    // Activation de l'état de chargement
    setState(() {
      _isLoading = true;
    });

    try {
      // Créer le contenu à partager
      String shareText = "Découvrez l'événement : ${event.evenementName}\n\n"
          "Organisé par : ${event.organizerName}\n"
          "Description de l'événement : ${event.description}\n\n"
          "Cliquer sur ce lien pour installer l'application et pour s'inscrire à cet évenement : https://ipnetuniversity.com/#/projets";

      // Récupérer la première URL d'image de l'événement (si disponible)
      String imageUrl = event.imageUrls.isNotEmpty ? event.imageUrls[0] : '';

      // Vérifier si une URL d'image est disponible
      if (imageUrl.isNotEmpty) {
        // Télécharger l'image à partir de l'URL et la stocker temporairement
        final ByteData imageData = await NetworkAssetBundle(Uri.parse(imageUrl))
            .load("");
        final Uint8List bytes = Uint8List.view(imageData.buffer);
        final File tempFile = await File(
            '${(await getTemporaryDirectory()).path}/temp_event_image.png')
            .create();
        await tempFile.writeAsBytes(bytes);

        // Partager le contenu avec l'image et la description
        await Share.shareFiles(
            [tempFile.path], text: shareText, subject: event.evenementName);
      } else {
        // Partager le contenu sans image
        await Share.share(shareText, subject: event.evenementName);
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Erreur lors du partage de l'événement : $e");
      setState(() {
        _isLoading = false;
      });
    }
  }
  // La désinscription sur cette page ce fait grace aux donner sur firebase
  Future<void> _EventDesinscription(Event event) async {
    try {
      String userId = AuthenticationService().getCurrentUserId();

      DocumentReference eventRef = FirebaseFirestore.instance
          .collection('User')
          .doc(event.organizerId)
          .collection('Evenement')
          .doc(event.id);

      // Mettre à jour les champs registeredCount et registeredUsers de l'événement
      await eventRef.update({
        'registeredCount': FieldValue.increment(-1),
        'registeredUsers': FieldValue.arrayRemove([userId]),
      });

      // Supprimer les informations de l'événement de la sous-collection de l'utilisateur inscrit
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

  confirmDesinscription(Event event) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Désinscrire à l'événement"),
          content: Text("Êtes-vous sûr de vouloir vous désinscrire de cet événement ?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                await _EventDesinscription(event); // Utilisez _EventDesinscription ici
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: Text("Désinscrire"),
            ),
          ],
        );
      },
    );
  }
  void _filterEvents(String query) {
    setState(() {
      filteredEvents = events.where((event) =>
      event.evenementName.toLowerCase().contains(query.toLowerCase()) ||
          event.organizerName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _refreshEvents() async {
    await fetchEvents();
    setState(() {});
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filterEvents('');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching
          ? AppBar(
            title: TextField(
            controller: _searchController,
            onChanged: _filterEvents,
            decoration: InputDecoration(
            hintText: 'Rechercher un événement',
            border: InputBorder.none,
            suffixIcon: IconButton(
              onPressed: _toggleSearch,
              icon: Icon(Icons.close),
            ),
            ),
          ),
           actions: [
            IconButton(
              onPressed: _toggleSearch,
              icon: Icon(Icons.search),
           ),
          ],
      )
          : null, // Masque l'appBar lorsque _isSearching est false
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleSearch,
        child: Icon(Icons.search),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshEvents,
        child: Stack(
          children: [
            ListView.builder(
              itemCount: _isSearching ? filteredEvents.length : events.length,
              itemBuilder: (context, index) {
                final event = _isSearching ? filteredEvents[index] : events[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsEventInscrit(event: event),
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
                              event.imageUrls.isNotEmpty
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: event.imageUrls[0],
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
                                  Text(event.evenementName),
                                  const SizedBox(height: 8),
                                  Text(event.organizerName),
                                ],
                              ),
                            ],
                          ),
                          PopupMenuButton(
                            onSelected: (value) async {
                              if (value == 'désinscrire') {
                                confirmDesinscription(events[index]);
                              } else if (value == 'share') {
                                await shareEvent(events[index]);
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                value: 'désinscrire',
                                child: ListTile(
                                  leading: Icon(
                                      Icons.cancel, color: Colors.red),
                                  title: Text("Désinscrire"),
                                )
                              ),
                              PopupMenuItem(
                                value: 'share',
                                child: ListTile(
                                  leading: Icon(Icons.share,
                                      color: Color(0xFF2196F3)),
                                  title: Text("Partager"),
                                )
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
            if (_isLoading)
              Container(
                color: Colors.black12.withOpacity(0.8),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
