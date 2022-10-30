import 'package:fire_app/Auth/loginScreen.dart';
import 'package:fire_app/Utils/utils.dart';
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
  bool loading = false;

  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();

    // Jb memory men inki zarurat na rahe tou inko remove krdo

    emailController.dispose();
    passwordController.dispose();
  }


void signup() {
if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      _auth
          .createUserWithEmailAndPassword(
              email: emailController.text.toString(),
              password: passwordController.text.toString())
          .then((value) {
        setState(() {
          loading = false;
        });
        // kaam hojaanay k baad yeh krna
      }).onError((error, stackTrace) {
        setState(() {
          loading = false;
        });
        // kaam na ho aur error aajayen tou yeh krna
        Utils.toastsMessage(error.toString());
      });
    }
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
                    isLoading: loading,
                    title: "Sign Up",
                    onPress: signup
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
