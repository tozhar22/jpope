
import 'package:flutter/foundation.dart';
import '../models/Event.dart';

class EventState extends ChangeNotifier {
  List<Event> publishedEvents = [];

  void setPublishedEvents(List<Event> events) {
    publishedEvents = events;
    notifyListeners();
  }
}
