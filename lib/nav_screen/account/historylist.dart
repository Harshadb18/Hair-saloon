import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryListbuilder extends StatefulWidget {
  final String date;
  final String timeslot;
  final String serviceID;
  final String userID;
  const HistoryListbuilder(
      this.date, this.timeslot, this.serviceID, this.userID,
      {super.key});

  @override
  State<HistoryListbuilder> createState() => _HistoryListbuilderState();
}

String? category;

class _HistoryListbuilderState extends State<HistoryListbuilder> {
  @override
  late String serviceName;
  late String imgUrl;

  late String gender;
  @override
  void initState() async {
    super.initState();
    fetchdata();
  }

  Future<void> fetchdata() async {
    DocumentSnapshot servicesnapshot = await FirebaseFirestore.instance
        .collection('services')
        .doc(widget.serviceID)
        .get();
    if (servicesnapshot.exists) {
      imgUrl = servicesnapshot['imgUrl'];
      category = servicesnapshot['category'];
      gender = servicesnapshot['gender'];
    }
  }

  @override
  Widget build(BuildContext context) {
    /*Future<void> fetchData(String userid, String serviceid) async {
      try {
        DocumentSnapshot servicesnapshot = await FirebaseFirestore.instance
            .collection('services')
            .doc(serviceID)
            .get();
        if (servicesnapshot.exists) {
          Map<String, dynamic> serviceData =
              servicesnapshot.data() as Map<String, dynamic>;
          serviceName = serviceData['name'];
          imgUrl = serviceData['imgUrl'];
          category = serviceData['category'];
          gender = serviceData['gender'];
        }
      } catch (e) {
        print("Error : $e");
      }
    }*/

    return Container(
      child: Text('$category'),
    );
  }
}
