import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_app/Auth/loginScreen.dart';
import 'package:fire_app/FireStore/FireStoreAddScreen.dart';
import 'package:fire_app/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostScreenFireStore extends StatefulWidget {
  const PostScreenFireStore({super.key});

  @override
  State<PostScreenFireStore> createState() => _PostScreenFireStoreState();
}

class _PostScreenFireStoreState extends State<PostScreenFireStore> {
  final auth = FirebaseAuth.instance;
  final updateController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection("Users").snapshots();
  //
  final CollectionReference refs =
      FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Your FireStore Posts"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const LoginScreen())));
              }).then((value) {
                Utils.toastsMessage("Your Logged Out!");
              }).onError((error, stackTrace) {
                Utils.toastsMessage("Login was not Successfull");
              });
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: firestore,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return const Text("Some Error has Occured");
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      title:
                          Text(snapshot.data!.docs[index]["title"].toString()),
                      subtitle:
                          Text(snapshot.data!.docs[index]["id"].toString()),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  showDialogBoxForUpdation(
                                      snapshot.data!.docs[index]["title"]
                                          .toString(),
                                      snapshot.data!.docs[index]["id"]
                                          .toString());
                                },
                                title: const Text("Edit"),
                                trailing: const Icon(Icons.edit),
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  refs
                                      .doc(snapshot.data!.docs[index]["id"])
                                      .delete()
                                      .then((value) {
                                    Utils.toastsMessage("Deleted Successfully");
                                  }).onError((error, stackTrace) {
                                    Utils.toastsMessage(error.toString());
                                  });
                                },
                                title: const Text("Delete"),
                                trailing: const Icon(Icons.delete),
                              ),
                            ),
                          ];
                        },
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddPostFireStore()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget PopUpMenu(String title, String id) {
    return PopupMenuButton(
        icon: const Icon(Icons.more_vert),
        itemBuilder: ((context) {
          return [
            PopupMenuItem(
              value: 1,
              child: ListTile(
                title: const Text("Edit"),
                leading: const Icon(Icons.edit),
                onTap: () {
                  Navigator.pop(context);
                  showDialogBoxForUpdation(title, id);
                },
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: ListTile(
                title: const Text("Delete"),
                leading: const Icon(Icons.delete),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ];
        }));
  }

  Future<void> showDialogBoxForUpdation(String title, String id) async {
    updateController.text = title;
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text("Update"),
            content: TextFormField(
              controller: updateController,
              decoration: const InputDecoration(
                hintMaxLines: 4,
                border: OutlineInputBorder()),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Update Method
                  refs
                      .doc(id)
                      .update({"title": updateController.text.toString()}).then(
                          (value) {
                    Utils.toastsMessage("Updated !");
                  }).onError((error, stackTrace) {
                    Utils.toastsMessage(error.toString());
                  });
                },
                child: const Text("Update"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              )
            ],
          );
        }));
  }
}
