import 'package:fire_app/Utils/utils.dart';
import 'package:fire_app/Widgets/roundButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref("Post");
  final postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Something"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            TextFormField(
              controller: postController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: "What's on your mind ?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              title: "Add",
              isLoading: loading,
              onPress: () {
                setState(() {
                  loading = true;
                });

                // alag se variable is liay banaya hai k change na ho!
                String id = DateTime.now().millisecondsSinceEpoch.toString();

                databaseRef.child(id).set({
                  "id": id,
                  "title": postController.text.toString()
                }).then((value) {
                  setState(() {
                    postController.clear();
                    loading = false;
                  });
                  Utils.toastsMessage("Posted!");
                }).onError((error, stackTrace) {
                  Utils.toastsMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
