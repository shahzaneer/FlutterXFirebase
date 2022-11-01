import 'dart:async';
import 'package:fire_app/Auth/loginScreen.dart';
import 'package:fire_app/FireStore/firestore_posts.dart';
import 'package:fire_app/UI/PostScreen.dart';
import 'package:fire_app/imagepic/imageupload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  static void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;

// ger user login ho tou post screen dhikhao
    if (auth.currentUser != null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(
              context,
              // MaterialPageRoute(builder: ((context) => const PostScreen()))));        // Firebase Realtime DB's Post Screen
              MaterialPageRoute(builder: ((context) => const PostScreenFireStore()))));
              // MaterialPageRoute(
              //     builder: ((context) => const ImageUploadScreen()))));
    }

    // wagirna Login krwao
    else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const LoginScreen()))));
    }
  }
}
