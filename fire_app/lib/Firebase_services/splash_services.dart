import 'dart:async';

import 'package:fire_app/Auth/loginScreen.dart';
import 'package:flutter/material.dart';

class SplashServices {
  static void isLogin(BuildContext context) {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const LoginScreen()))));
  }
}
