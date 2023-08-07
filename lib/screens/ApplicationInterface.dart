
import 'package:flutter/material.dart';
import 'package:jpope/screens/PageAccueil.dart';
import 'package:jpope/screens/PageEvenement.dart';
import 'package:jpope/screens/PagePlaning.dart';
import 'package:jpope/screens/PageRecherche.dart';
import 'package:jpope/widgets/NavBar.dart';

import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';


class ApplicationInterface extends StatefulWidget {
  ApplicationInterface({Key? key,}) : super(key: key);


  @override
  State<ApplicationInterface> createState() => _ApplicationInterfaceState();
}

class _ApplicationInterfaceState extends State<ApplicationInterface> {


  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;



  // création d'une méthode qui se chargera de changer le numero de la variable

  setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _onBottomNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        drawer: NavBar(), // Use the correct syntax here
        appBar: AppBar(
          title: const Text(
            "EventPlan",
            style: TextStyle(
              fontFamily: 'Russo_One',
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
          backgroundColor: Colors.blueAccent,
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: setCurrentIndex,
          children: const [
            Accueil(),
            PageEvenement(),
            Planning(),
            Search()
          ],
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: _onBottomNavItemTapped,
          items: [
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Accueil"),
              selectedColor: Colors.blueAccent,
            ),

            SalomonBottomBarItem(
              icon: Icon(Icons.add_circle),
              title: Text("Evenement"),
              selectedColor: Colors.blueAccent,
            ),

            SalomonBottomBarItem(
              icon: Icon(Icons.calendar_month),
              title: Text("Planning"),
              selectedColor: Colors.blueAccent,
            ),

            SalomonBottomBarItem(
              icon: Icon(Icons.search),
              title: Text("Recherche"),
              selectedColor: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}