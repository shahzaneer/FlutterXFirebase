import 'package:fire_app/Auth/loginScreen.dart';
import 'package:fire_app/Widgets/roundButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
        title: const Text("FireApp Signup"),
        centerTitle: true,
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
                    title: "Sign Up",
                    onPress: () {
                      if (!_formKey.currentState!.validate()) {
                        print("BHarose walo fields tou fill karo pehle");
                      }
                      if (_formKey.currentState!.validate()) {
                        _auth.createUserWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordController.text.toString());
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
              const Text("Already Have an Account? "),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return LoginScreen();
                  })));
                },
                child: const Text("Login"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
