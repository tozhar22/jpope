
import 'package:jpope/screens/Qr-code.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/Event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetailsEventInscrit extends StatelessWidget {
  const DetailsEventInscrit({super.key, required this.event});
  final Event event;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'événement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: event.imageUrls[0],
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(height: 16.0),
              Text(
                event.evenementName,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    'Organisé par: ${event.organizerName}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    'Date: ${event.date}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(
                    Icons.location_city,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    'Ville: ${event.ville}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(
                    Icons.place,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    'Lieu: ${event.lieu}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                'Description:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                event.description,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[900],
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Votre QR Code:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8.0),
              Card(
                child: ListTile(
                  title: Center(child: const Text('QR-CODE',style: TextStyle(fontWeight: FontWeight.bold),)),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRCodePage(event)
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

