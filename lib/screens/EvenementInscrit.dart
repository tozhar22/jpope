import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jpope/screens/DetailsEvenementsInscrit.dart';
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

      print(events[1].organizerName + 'rien');
    } catch (e) {
      print("Erreur lors de la récupération des événements : $e");
    }
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
                        builder: (context) =>
                            DetailsEventInscrit(event: event),
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
                                  const SizedBox(height: 8,),
                                  Text(event.organizerName),
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
            if (_isLoading)
              Container(
                color: Colors.black12.withOpacity(0.8), // Couleur de fond semi-transparente
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
