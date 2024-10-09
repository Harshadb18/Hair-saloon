import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_client/login/login.dart';
import 'package:salon_client/nav_screen/account/history.dart';
import 'package:salon_client/nav_screen/edit_profile.dart';
import 'package:salon_client/utils/label_container.dart';

class ProfilePage extends StatelessWidget {
  final String userId;
  final BuildContext context;

  const ProfilePage(this.userId, this.context, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Center(child: Text('No data found!'));
        } else {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String name = userData['firstName'] + ' ' + userData['secondName'];
          String email = userData['email'];
          String profileImageUrl = userData['file'];

          return buildProfileUI(name, email, profileImageUrl);
        }
      },
    );
  }

  Widget buildProfileUI(String name, String email, String profileImageUrl) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              email,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Labelcontainer(
                title: 'Edit Profile',
                subtitle: 'Name, Email, Profile',
                icon: Icons.account_box_outlined,
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage(userId)));
                }),
            const SizedBox(height: 20),
            Labelcontainer(
                title: 'Password',
                subtitle: 'change password',
                icon: Icons.key_outlined,
                ontap: () {}),
            const SizedBox(height: 20),
            Labelcontainer(
                title: 'History',
                subtitle: 'Past bookings, Payments',
                icon: Icons.history_rounded,
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BookingHistory()));
                }),
            const SizedBox(height: 120),
            ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              icon: const Icon(Icons.exit_to_app), // Logout icon
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Change button color
              ),
            )
          ],
        ),
      ),
    );
  }
}




/*import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon_client/utils/image_picker.dart';

class Accountscreen extends StatefulWidget {
  const Accountscreen({super.key});

  @override
  State<Accountscreen> createState() => _AccountscreenState();
}

class _AccountscreenState extends State<Accountscreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _user;
  bool _isLoading = false;
  String? email;
  String? firstname;
  String? lastname;
  String? img_url;
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future<void> _getUser() async {
    setState(() {
      _isLoading = true;
    });
    _user = _auth.currentUser!;
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(_user.uid).get();

    setState(() {
      email = userDoc['email'];
      firstname = userDoc['firstName'];
      lastname = userDoc['secondName'];
      img_url = userDoc['file'];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  'https://png.pngitem.com/pimgs/s/421-4212266_transparent-default-avatar-png-default-avatar-images-png.png')),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),
                  Text(
                    'Name: $firstname',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Email: ',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
    );
  }
}
*/