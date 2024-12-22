import 'package:flutter/material.dart';
import 'package:maan/ApiServices/ApiServices.dart';
import 'package:maan/Presentations/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Future<void> initState() async {
    super.initState();
    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    String pass = prefs.getString('password') ?? '';
    if (pass == '') {
      print('object');
      ApiFunctions().checkUserStatus();
    } else {
      ApiFunctions().login(email: email, password: pass, context: context);
    }

    Future.delayed(const Duration(seconds: 1), () {
      _navigateToScreen(context, const SecondScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.gif"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: const Color.fromARGB(255, 247, 244, 244).withOpacity(0.9),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/namaste .gif',
              width: 600,
              height: 600,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Image.asset(
                "assets/images/madeinindia.gif",
                height: 600,
                width: 600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to HomeScreen after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      _navigateToScreen(context, HomePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.gif"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: const Color.fromARGB(255, 249, 247, 247).withOpacity(0.9),
            ),
          ),
          // Centered room.gif
          Center(
            child: Image.asset(
              'assets/images/room.gif',
              width: 600,
              height: 600,
              fit: BoxFit.contain,
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Image.asset(
                "assets/images/madeinindia.gif",
                height: 600,
                width: 600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _navigateToScreen(BuildContext context, Widget destination) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destination,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final opacityAnimation = animation.drive(
          Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        );
        return FadeTransition(opacity: opacityAnimation, child: child);
      },
    ),
  );
}
