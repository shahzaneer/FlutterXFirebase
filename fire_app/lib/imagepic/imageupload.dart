import 'dart:io';
import 'package:fire_app/Utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fire_app/Widgets/roundButton.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  final imagePicker = ImagePicker();
  bool loading = false;

  DatabaseReference refDatabase = FirebaseDatabase.instance.ref("Post");
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> pickImageFromGallery() async {
    final pickedFile = (await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 80));

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        debugPrint("No Image Picked");
      }
    });
  }

  Future<void> pickImageFromCamera() async {
    final pickedFile = (await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 80));

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        debugPrint("No Image Picked");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () {
                // pickImageFromGallery();
                pickImageFromCamera();
              },
              child: Ink(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _image != null
                    ? Image.file(
                        _image!.absolute,
                        fit: BoxFit.fill,
                      )
                    : const Icon(Icons.image),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          RoundButton(
            isLoading: loading,
            title: "Upload",
            onPress: (() async {
              setState(() {
                loading = true;
              });
              firebase_storage.Reference ref =
                  firebase_storage.FirebaseStorage.instance.ref(
                      '/ShahzaneerFolder/${DateTime.now().millisecondsSinceEpoch}');
              firebase_storage.UploadTask uploadTask =
                  ref.putFile(_image!.absolute);

              await Future.value(uploadTask).then((value) async {
                final URL = await ref.getDownloadURL();

                refDatabase
                    .child("1")
                    .set({"id": "1234", "title": URL.toString()});

                Utils.toastsMessage("Posted!");

                setState(() {
                  loading = false;
                });
              }).onError((error, stackTrace) {
                Utils.toastsMessage(error.toString());
                setState(() {
                  loading = false;
                });
              });
            }),
          )
        ],
      ),
    );
  }
}
