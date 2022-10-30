import 'package:fire_app/FireStore/firestore_posts.dart';
import 'package:fire_app/UI/PostScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/roundButton.dart';

class VerifyCode extends StatefulWidget {
  final String verificationid;
  const VerifyCode({super.key, required this.verificationid});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  bool loading = false;
  final _phoneCodeController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verification Code"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          TextFormField(
            keyboardType: TextInputType.phone,
            controller: _phoneCodeController,
            decoration: const InputDecoration(
              hintText: "6 Digit Code",
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          RoundButton(
              title: "Login",
              isLoading: loading,
              onPress: () async {
                setState(() {
                  loading = true;
                });
                //  Making Credentials
                final credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationid,
                  smsCode: _phoneCodeController.text.toString(),
                );

                try {
                  await _auth.signInWithCredential(credential);
                  setState(() {
                    loading = false;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PostScreenFireStore()));
                } catch (e) {
                  setState(() {
                    //  When App is in released mode these debug Print Statements are considered commented
                    debugPrint(e
                        .toString()); // no warning of using print statement in Production
                    loading = false;
                  });
                }
              }),
        ],
      ),
    );
  }
}
