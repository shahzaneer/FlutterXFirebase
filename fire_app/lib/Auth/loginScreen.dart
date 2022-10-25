import 'package:fire_app/Widgets/roundButton.dart';
import 'package:flutter/material.dart';

import 'SignupSreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    // Jb memory men inki zarurat na rahe tou inko remove krdo

    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FireApp Login"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Email cannot be empty!";
                      } else {
                        return null;
                      }
                    }),
                    decoration: const InputDecoration(
                        hintText: "  Enter Email",
                        prefixIcon: Icon(Icons.email_rounded)),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: passwordController,
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Password cannot be empty!";
                      } else {
                        return null;
                      }
                    }),
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "  Enter Password",
                      prefixIcon: Icon(Icons.security_sharp),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  RoundButton(
                    title: "Login",
                    onPress: () {
                      if (!_formKey.currentState!.validate()) {
                        print("BHarose walo fields tou fill karo pehle");
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't Have an Account? "),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return const SignUpScreen();
                  })));
                },
                child: const Text("Sign Up"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
