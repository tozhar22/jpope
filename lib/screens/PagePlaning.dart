import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/Event.dart';
import '../services/FirebaseAuthServices.dart';
class PlanningPage extends StatefulWidget {

  const PlanningPage({Key? key}) : super(key: key);
  @override
  State<PlanningPage> createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {

  late final CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Event>> _eventsData = {}; // Associe les dates aux événements

  @override
  void initState() {
    super.initState();
    _loadEventData();
  }

  void _loadEventData() async {
    String userId = AuthenticationService().getCurrentUserId(); // Récuper l'id de l'utilisateur connecter
    print(userId);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('User').doc(userId).collection('Evenement_cree').get();
    List<Event> events = querySnapshot.docs.map((doc) => Event.fromFirestore(doc.data() as Map<String, dynamic>)).toList();

    // Associez les événements aux dates dans la map
    for (var event in events) {
      DateTime eventDate = DateTime(event.date.year, event.date.month, event.date.day); // Ignorer l'heure
      _eventsData[eventDate] = _eventsData[eventDate] ?? [];
      _eventsData[eventDate]?.add(event);
    }
    // Affichez le contenu de _eventsData dans la console
    _eventsData.forEach((date, events) {
      print('$date: ${events.length} événements');
    });

    setState(() {}); // Rafraîchir l'interface pour afficher les événements sur le calendrier
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              calendarFormat: _calendarFormat,
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2050, 12, 31),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                markersAnchor: Colors.yellow.opacity, // Couleur pour les dates avec des événements
              ),
              eventLoader: (day) => _eventsData[day] ?? [],
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                _selectedDay != null
                    ? 'Selected Day: ${_selectedDay!.toLocal()}'
                    : 'No day selected',
              ),
            ),
          ],
        ),
      ),
    );
  }
}