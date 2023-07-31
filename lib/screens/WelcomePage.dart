

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key});

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  height: 150,
                ),
                Text(
                  "EventPlan",
                  style: TextStyle(
                    fontSize: 35,
                    color: Color(0xFF2196F3),
                    fontFamily: 'Russo_One',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 70,),
            Center(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 400,
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
                            SizedBox(height: 30),
                            Text(""
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
            SizedBox(height: 40,),
            BounceInDown(
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "S'incrire gratuitement",
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.only(left: 75, right: 75, top: 10, bottom: 10),
                ),
              ),
            ),
            ElevatedButton(
              onPressed:(){},
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
      ),
    );
  }
}