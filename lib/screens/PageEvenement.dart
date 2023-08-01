import 'package:flutter/material.dart';

class PageEvenement extends StatefulWidget {
  const PageEvenement({super.key});

  @override
  State<PageEvenement> createState() => _PageEvenementState();
}

class _PageEvenementState extends State<PageEvenement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FloatingActionButton(
              onPressed: null,
              child: Icon(
                Icons.add,
              ),
          )
        ],
      ),
    );
  }
}
