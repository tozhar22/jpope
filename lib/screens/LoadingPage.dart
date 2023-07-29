
import 'package:flutter/material.dart';

class loadingPage extends StatelessWidget {
  const loadingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2550B8),
              Color(0xFF5A58C6),
              Color(0xFF9964D8),
              Color(0xFFA367D9),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png'),
            ],
          ),
        ),
      ),
    );
  }
}
