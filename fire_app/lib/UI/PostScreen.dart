import 'package:fire_app/Auth/loginScreen.dart';
import 'package:fire_app/UI/add_post.dart';
import 'package:fire_app/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final refs = FirebaseDatabase.instance.ref("Post");
  final SearchFilterController = TextEditingController();
  final updateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Your Posts"),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextFormField(
              controller: SearchFilterController,
              decoration: const InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
              onChanged: ((value) {
                setState(() {
                  // Rebuild the widget Broooo
                });
              }),
            ),
          ),
          //! First way for listing the contents from the Firebase DB is using the FirebaseAnimatedList
          Expanded(
            child: FirebaseAnimatedList(
              defaultChild: const Text("Loading..."),
              query: refs,
              itemBuilder: ((context, snapshot, animation, index) {
                final title = snapshot.child("title").value.toString();

                if (SearchFilterController.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.child("title").value.toString()),
                    subtitle: Text(snapshot.child("id").value.toString()),
                    trailing:
                        PopUpMenu(title, snapshot.child("id").value.toString()),
                  );
                } else if (title
                    .toLowerCase()
                    .contains(SearchFilterController.text.toLowerCase())) {
                  return ListTile(
                    title: Text(snapshot.child("title").value.toString()),
                    subtitle: Text(snapshot.child("id").value.toString()),
                    trailing:
                        PopUpMenu(title, snapshot.child("id").value.toString()),
                  );
                } else {
                  return Container();
                }
              }),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPost()));
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
                  // method calling to remove the ID from the DB 
                  refs.child(id).remove();
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
            content: TextField(
              controller: updateController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  // Update Method
                  refs
                      .child(id)
                      .update({"title": updateController.text.toString()}).then(
                          (value) {
                    Utils.toastsMessage("Updated!");
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

//! Second way for listing the contents from the Firebase DB is using the Stream Builder

// Expanded(
//             child: StreamBuilder(
//               stream: refs.onValue, // firebase DB ka ref
//               builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//                 if (!snapshot.hasData) {
//                   return const CircularProgressIndicator(
//                     color: Colors.pink,
//                   );
//                 } else {
//                 // converting the data into a list from firebase DB

//                   Map<dynamic, dynamic> map =
//                       snapshot.data!.snapshot.value as dynamic;
//                   List<dynamic> list = [];
//                   list.clear();
//                   list = map.values.toList();

//                   return ListView.builder(
//                     itemCount: snapshot.data!.snapshot.children.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(list[index]["title"].toString()),
//                         subtitle: Text(list[index]["id"].toString()),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),

