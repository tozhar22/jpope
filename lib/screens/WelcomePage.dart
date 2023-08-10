import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jpope/screens/Authentification.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'inscription.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  final _currentPageNotifier = ValueNotifier<int>(0);
  bool _isPageScrolling = true; // Démarre le scrolling automatique au démarrage

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_isPageScrolling) {
        int nextPage = _pageController.page!.toInt() + 1;
        if (nextPage >= 3) {
          nextPage = 0;
          // Réinitialise le PageController pour revenir à la première page
          _pageController.jumpToPage(0);
        }
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
        _currentPageNotifier.value = nextPage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: screenHeight * 0.15,
              ),
              Text(
                "EventPlan",
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  color: Color(0xFF2196F3),
                  fontFamily: 'Russo_One',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.1),
          Center(
            child: Column(
              children: [
                Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.5,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      _currentPageNotifier.value = page;
                    },
                    children: [
                      Column(
                        children: [
                          SvgPicture.asset("assets/images/evenement.svg", width: 300),
                          SizedBox(height: 30),
                          Text(
                            "Crée un événement",
                            style: TextStyle(
                                fontSize: 18
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SvgPicture.asset("assets/images/tache.svg", width: 300),
                          SizedBox(height: 30),
                          Text(
                            "Gérez tout, sans souci",
                            style: TextStyle(
                                fontSize: 18
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SvgPicture.asset("assets/images/time.svg", width: 300),
                          SizedBox(height: 28),
                          Text(
                              "Moins de tracas, plus de temps pour vous",
                            style: TextStyle(
                                fontSize: 18
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CirclePageIndicator(
                  itemCount: 3,
                  currentPageNotifier: _currentPageNotifier,
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.04),
          BounceInDown(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Inscription()),
                );
              },
              child: Text(
                "S'inscrire gratuitement",
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.1),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.15,
                  vertical: screenHeight * 0.01,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Authentification()),
              );
            },
            child: Text(
              "Vous avez un compte ? Connectez-vous",
              style: TextStyle(
                  color:  Colors.grey,
                  fontSize: 15
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              elevation: MaterialStateProperty.all(0),
            ),
          )
        ],
      ),
    );
  }
}