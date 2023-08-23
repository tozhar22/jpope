import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/Event.dart';
class QRCodePage extends StatelessWidget {
  final Event event;

  QRCodePage(this.event);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Fond blanc
        child: Center(
          child: QrImageView(
            data: event.qrData,
            version: QrVersions.auto,
            size: 260.0,
          ),
        )
      ),
    );
  }
}