import 'package:fire_app/Utils/utils.dart';
import 'package:fire_app/Widgets/roundButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
                hintText: "Email", border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 30.0,
          ),
          RoundButton(
              title: "Retrive password",
              onPress: () {
                _auth
                    .sendPasswordResetEmail(
                        email: emailController.text.toString())
                    .then((value) {
                  Utils.toastsMessage("The Password reset link has been sent!");
                }).onError((error, stackTrace) {
                  Utils.toastsMessage(error.toString());
                });
              })
        ],
      ),
    );
  }
}
