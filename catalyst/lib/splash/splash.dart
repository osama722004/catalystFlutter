import 'dart:convert';
import 'package:catalyst/login/login_view.dart';
import 'package:flutter/material.dart';

// import 'package:http/';
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double firstAnimatedContainer = 0;
  double scendAnimatedContainer = 0;
  double thirdAnimatedContainer = 0;
  double fourthAnimatedContainer = 0;
  double fifthAnimatedContainer = 0;
  double animatedOpacity = 0;
  double animatedPadding = 150;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        firstAnimatedContainer = -600;
      });
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        scendAnimatedContainer = -600;
      });
    });
    Future.delayed(Duration(milliseconds: 1250), () {
      setState(() {
        thirdAnimatedContainer = -600;
      });
    });
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        fourthAnimatedContainer = -600;
      });
    });
    Future.delayed(Duration(milliseconds: 1600), () {
      setState(() {
        fifthAnimatedContainer = -600;
      });
    });
    Future.delayed(Duration(milliseconds: 1600), () {
      setState(() {
        animatedOpacity = 1;
        animatedPadding = 0;
      });
    });
    Future.delayed(Duration(milliseconds: 3000), () {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoginView(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
            transitionDuration: Duration(seconds: 1)),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(children: [
            AnimatedContainer(
              curve: Curves.easeInOut,
              width: MediaQuery.of(context).size.width,
              duration: Duration(seconds: 1),
              transform:
                  Matrix4.translationValues(firstAnimatedContainer, 0, 0),
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(174, 227, 255, 1.0),
              ],begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                  )),
            ),
            AnimatedContainer(
              curve: Curves.easeInOut,
              width: MediaQuery.of(context).size.width,
              duration: Duration(seconds: 1),
              transform:
                  Matrix4.translationValues(scendAnimatedContainer, 0, 0),
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(174, 227, 255, 1.0),
                    Color.fromRGBO(147, 218, 255, 1.0),
                  ],begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  )),
            ),
            AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(seconds: 1),
              transform:
                  Matrix4.translationValues(thirdAnimatedContainer, 0, 0),
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(147, 218, 255, 1.0),
                    Color.fromRGBO(113, 205, 253, 1.0),
                  ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  )),
            ),
            AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(seconds: 1),
              transform:
                  Matrix4.translationValues(fourthAnimatedContainer, 0, 0),
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(113, 205, 253, 1.0),
                    Color.fromRGBO(86, 196, 255, 1.0),
                  ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  )),
            ),
            AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(seconds: 1),
              transform:
                  Matrix4.translationValues(fifthAnimatedContainer, 0, 0),
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(86, 196, 255, 1.0),
                    Color.fromRGBO(77, 134, 156, 1)
              ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  )),
            ),
          ]),
          Center(
            child: AnimatedPadding(
              duration: Duration(seconds: 1),
              padding: EdgeInsets.only(top: animatedPadding),
              child: AnimatedOpacity(
                duration: Duration(seconds: 1),
                opacity: animatedOpacity,
                child: Image.asset(
                  'assets/images/splash.png',
                  height: 250,
                  width: 250,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
