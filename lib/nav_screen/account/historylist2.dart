import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_client/utils/history_container.dart';

class HistoryFetch extends StatelessWidget {
  final String date;
  final String timeSlot;
  final String serviceId;
  final String userId;

  const HistoryFetch(
      {super.key, required this.date,
      required this.timeSlot,
      required this.serviceId,
      required this.userId});

  Future<Map<String, dynamic>> fetchData(
      String serviceId, String userId) async {
    Map<String, dynamic> data = {};

    DocumentSnapshot serviceSnapshot = await FirebaseFirestore.instance
        .collection('services')
        .doc(serviceId)
        .get();

    if (serviceSnapshot.exists) {
      data['serviceName'] = serviceSnapshot['name'];
      data['category'] = serviceSnapshot['category'];
      data['price'] = serviceSnapshot['price'].toString();
      data['imageUrl'] = serviceSnapshot['imageUrl'];
    }

    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      data['userName'] =
          userSnapshot['firstName'] + ' ' + userSnapshot['secondName'];
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(serviceId, userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  HistoryContainer(
                      date,
                      timeSlot,
                      snapshot.data!['serviceName'],
                      snapshot.data!['category'],
                      snapshot.data!['imageUrl'],
                      snapshot.data!['price']),
                  const SizedBox(
                    height: 10,
                  )
                  //Text('Date: $date'),
                  //Text('Time Slot: $timeSlot'),
                  //Image.network(snapshot.data!['imageUrl']),
                  //Text('Service Name: ${snapshot.data!['serviceName']}'),
                  //Text('Category: ${snapshot.data!['category']}'),
                  //Text('Price: ${snapshot.data!['price']}'),
                  //Text('User Name: ${snapshot.data!['userName']}'),
                  //Image.network(snapshot.data!['imageUrl']),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
