
import 'package:flutter/material.dart';
import 'package:jpope/screens/AjoutEvenement.dart';

class PageEvenement extends StatefulWidget {
  const PageEvenement({super.key});

  @override
  State<PageEvenement> createState() => _PageEvenementState();
}

class _PageEvenementState extends State<PageEvenement> {
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> Navigator.push(
          context,
          PageRouteBuilder(pageBuilder: (_,__,___) =>AddEvent())
        ),
        child: Icon(Icons.add),
      ), //
    );
  }
}
