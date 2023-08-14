import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/Event.dart';
import '../services/FirebaseAuthServices.dart';

class EventCalendarPage extends StatefulWidget {
  @override
  _EventCalendarPageState createState() => _EventCalendarPageState();
}

class _EventCalendarPageState extends State<EventCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    String? userId = AuthenticationService().getCurrentUserId();

    final eventsSnapshot = await FirebaseFirestore.instance
        .collection('User')
        .doc(userId)
        .collection('Evenement_cree')
        .get();

    setState(() {
      events = eventsSnapshot.docs
          .map((doc) => Event.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events.where((event) {
      return event.date.year == day.year &&
          event.date.month == day.month &&
          event.date.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          SizedBox(height: 20),
          if (_selectedDay != null)
            Column(
              children: [
                Text(
                  'Événements pour le ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                if (_getEventsForDay(_selectedDay).isNotEmpty)
                  Column(
                    children: _getEventsForDay(_selectedDay)
                        .map((event) => ListTile(
                      title: Text(event.evenementName),
                      subtitle: Text(
                          'Heure : ${DateFormat('HH:mm').format(event.timestamp.toDate())}'),
                    ))
                        .toList(),
                  )
                else
                  Text('Aucun événement pour cette date'),
              ],
            ),
        ],
      ),
    );
  }
}