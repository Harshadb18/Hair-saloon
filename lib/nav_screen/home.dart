import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_client/services/beard.dart';
import 'package:salon_client/services/facial.dart';
import 'package:salon_client/services/haircut.dart';
import 'package:salon_client/services/others.dart';
import 'package:salon_client/utils/popular_container.dart';


import '../utils/category_builder.dart';
import '../utils/searchSecreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Map<String, dynamic>> result = [];

  Future<void> fetchData() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('bookings').get();

    Map<String, int> countMap = {};

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      String serviceId = document['selectedHairstyle'];
      countMap[serviceId] = (countMap[serviceId] ?? 0) + 1;
    }

    List<MapEntry<String, int>> sortedServiceIds = countMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    result = sortedServiceIds
        .map((serviceId) => {'serviceId': serviceId.key})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.7)),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.grey,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Search Hairstyle Here...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: 220,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 16),
                      CategoryContainer(
                          'Hair cut', 'assets/icons/mysalon.png', () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HairCut()));
                      }),
                      const SizedBox(width: 16),
                      CategoryContainer('Beard', 'assets/icons/beard.png',
                              () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Beard()));
                          }),
                      const SizedBox(width: 16),
                      CategoryContainer('Facial', 'assets/icons/facial.png',
                              () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Facial()));
                          }),
                      const SizedBox(width: 16),
                      CategoryContainer('Others', 'assets/icons/others.png',
                              () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Others()));
                          }),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Popular',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              FutureBuilder<void>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: 3,
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: 10.0),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(13),
                          child: PopularStyle(
                            documentId: result[index]['serviceId'],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
