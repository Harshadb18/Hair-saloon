import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StyleAi extends StatefulWidget {
  const StyleAi({Key? key}) : super(key: key);

  @override
  State<StyleAi> createState() => _StyleAiState();
}

class _StyleAiState extends State<StyleAi> {
  File? _image;

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('StyleAi'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? const Text('No image selected.')
                : Image.file(
              _image!,
              height: 400,
              width: 300,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    _getImage(ImageSource.camera); // To pick image from camera
                  },
                  icon: Icon(Icons.camera_alt_rounded),
                  iconSize: 48,
                  color: Colors.red,
                ),
                SizedBox(width: 40),
                IconButton(
                  onPressed: () {
                    _getImage(
                        ImageSource.gallery); // To pick image from gallery
                  },
                  icon: Icon(Icons.attach_file_rounded),
                  iconSize: 48,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
