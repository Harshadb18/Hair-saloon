import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;

  const EditProfilePage(this.userId, {Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? img_url;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      Map<String, dynamic> userDataMap =
      userData.data() as Map<String, dynamic>;
      _firstNameController.text = userDataMap['first_name'] ?? '';
      _lastNameController.text = userDataMap['last_name'] ?? '';
      img_url = userDataMap['file'];
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      try {
        final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profiles/${widget.userId}');
        await firebaseStorageRef.putFile(_imageFile!);
        String imageUrl = await firebaseStorageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update({
          'file': imageUrl,
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _updateProfileData() async {
    try {
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'firstName': firstName,
        'secondName': lastName,
      });
    } catch (e) {
      print('Error updating profile data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SafeArea(
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: Icon(Icons.photo_library),
                            title: Text('Photo Library'),
                            onTap: () {
                              _getImage(ImageSource.gallery);
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.photo_camera),
                            title: Text('Camera'),
                            onTap: () {
                              _getImage(ImageSource.camera);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Center(
                child: _imageFile != null
                    ? CircleAvatar(
                  radius: 50,
                  backgroundImage: FileImage(_imageFile!),
                )
                    : CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('$img_url'),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () async {
                await _uploadImage();
                await _updateProfileData();
                Navigator.of(context).pop();
              },
              child: Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
