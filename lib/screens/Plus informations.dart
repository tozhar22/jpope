import 'package:flutter/material.dart';
import '../models/Event.dart';

class MoreInfoDialog extends StatelessWidget {
  final Event event;

  const MoreInfoDialog({required this.event});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Informations détaillées',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(
              Icons.description,
              color: Colors.blue,
            ),
            title: const Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(event.description),
          ),
          ListTile(
            leading: const Icon(
              Icons.date_range,
              color: Colors.blue,
            ),
            title: const Text(
              'Date:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(event.date.toString()),
          ),
          ListTile(
            leading: const Icon(
              Icons.location_on,
              color: Colors.blue,
            ),
            title: const Text(
              'Lieu:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(event.region),
          ),
          // Ajoutez d'autres informations ici selon votre modèle Event
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Fermer'),
        ),
      ],
    );
  }
}