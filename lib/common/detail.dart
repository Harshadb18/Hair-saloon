import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../booking/book_appointment copy.dart';

class DetailsPage extends StatefulWidget {
  final String name;
  final String section;
  final String category;
  final String description;
  final num price;
  final String imageUrl;
  final String id;

  const DetailsPage({
    required this.name,
    required this.section,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late String _name;
  late String _section;
  late String _category;
  late String _description;
  late num _price;
  late String _imageUrl;
  late String _id;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _section = widget.section;
    _category = widget.category;
    _description = widget.description;
    _imageUrl = widget.imageUrl;
    _price = widget.price;
    _id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    _imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Name: $_name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Price: $_price',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Category: $_category',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sex: $_section',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Description:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(_description),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentBookingWidget(
                              hairstyleId: _id,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        textStyle: TextStyle(color: Colors.white),
                      ),
                      child: const Text('Book'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
