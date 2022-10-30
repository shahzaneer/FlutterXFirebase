import 'package:fire_app/Auth/login_code.dart';
import 'package:fire_app/Utils/utils.dart';
import 'package:fire_app/Widgets/roundButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  bool loading = false;
  final _phoneController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Via Phone"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          TextFormField(
            keyboardType: TextInputType.phone,
            controller: _phoneController,
            decoration: const InputDecoration(
              hintText: "+92 3164606490",
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          RoundButton(
              title: "Login",
              onPress: () {
                setState(() {
                  loading = true;
                });
                _auth.verifyPhoneNumber(
                    phoneNumber: _phoneController.text.toString(),
                    verificationCompleted: (_) {
                      setState(() {
                        loading = false;
                      });
                    },
                    verificationFailed: ((error) {
                      setState(() {
                        loading = false;
                      });
                      Utils.toastsMessage(error.toString());
                    }),
                    codeSent: ((verificationId, forceResendingToken) {
                      setState(() {
                        loading = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyCode(
                            verificationid: verificationId,
                          ),
                        ),
                      );
                    }),
                    codeAutoRetrievalTimeout: ((e) {
                      Utils.toastsMessage(e.toString());
                      setState(() {
                        loading = false;
                      });
                    }));
              }),
        ],
      ),
    );
  }
}


// ! Below command is used to find out the SHA1 SHA256 keys for android
// keytool -list -v -keystore "C:\Users\<UserName>\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android