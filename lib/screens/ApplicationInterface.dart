import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jpope/screens/PageAccueil.dart';
import 'package:jpope/screens/PageEvenement.dart';
import 'package:jpope/screens/PagePlaning.dart';
import 'package:jpope/screens/PageRecherche.dart';
import 'package:jpope/services/FirebaseAuthServices.dart';
import 'package:jpope/widgets/NavBar.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class ApplicationInterface extends StatefulWidget {
  ApplicationInterface({Key? key}) : super(key: key);

  @override
  State<ApplicationInterface> createState() => _ApplicationInterfaceState();
}

class _ApplicationInterfaceState extends State<ApplicationInterface> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;
   String _name = "Admin";
   String _email = "admin@gmail.com";
   bool _isAdmin = false;
  @override
  void initState() {
    super.initState();
    _fetchUserData();

  }
  // methode qui recuper les infos de l'utlisateur et vérifier si il est administrateru
  Future<void> _fetchUserData() async {
    try {
      final userId = AuthenticationService().getCurrentUserId();

      if (userId.isNotEmpty) {
        final userDoc = await FirebaseFirestore.instance.collection('User').doc(userId).get();
        if (userDoc.exists) {
          final username = userDoc['userName'] ?? "admin";
          final email = userDoc['mail'] ?? "admin@gmail.com";

          setState(() {
            _name = username;
            _email = email;
          });

          final adminDoc = await FirebaseFirestore.instance.collection('AdminUser').doc(userId).get();
          final isAdmin = adminDoc.exists;

          setState(() {
            _isAdmin = isAdmin;
          });
        }
      }
    } catch (e) {
      print("Error fetching user info: $e");
    }
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: NavBar(name:_name,email: _email,isAdmin: _isAdmin),
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
          onPageChanged: _onBottomNavItemTapped,
          children: [
            const Accueil(),
            const PageEvenement(),
            EventCalendarPage(),
            const Search()
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
