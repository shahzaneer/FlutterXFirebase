import 'package:fire_app/Firebase_services/splash_services.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    SplashServices.isLogin(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.pink.shade100,
            Colors.pink.shade200,
            Colors.pink.shade300,
            Colors.pink.shade400,
            Colors.pink.shade500,
            Colors.pink.shade700,
          ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
        ),
        const Center(
          child: Text(
            "Let us Fire the App",
            style: TextStyle(fontSize: 25),
          ),
        ),
      ],
    ));
  }
}
