import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salon_client/nav_screen/account/historylist2.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({super.key});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String? currentUserId;
  DateTime today = DateTime.now();
  late String formattedToday;

  @override
  void initState() {
    super.initState();
    formattedToday = "${today.year}-${today.month}-${today.day}";
    User? user = _auth.currentUser;

    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('bookings')
              .where('bookingDate', isLessThan: formattedToday)
              .orderBy('bookingDate')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No data available.'));
            }

            User? user = _auth.currentUser;
            final documents = snapshot.data!.docs;
            final Data = documents
                .where((doc) => doc['userId'].contains(currentUserId))
                .toList();

            if (Data.isEmpty) {
              return const Center(child: Text('No data available.'));
            }

            return ListView.builder(
              itemCount: Data.length,
              itemBuilder: (context, index) {
                final doc = Data[index];

                return Column(
                  children: [
                    HistoryFetch(
                        date: doc['bookingDate'].toString(),
                        timeSlot: doc['selectedTimeSlot'].toString(),
                        serviceId: doc['selectedHairstyle'],
                        userId: doc['userId']),
                    /*HistoryListbuilder(
                        doc['bookingDate'].toString(),
                        doc['selectedTimeSlot'].toString(),
                        doc['selectedHairstyle'],
                        doc['userId']),*/
                    /*Text(
                      doc['bookingDate'].toString(),
                    ),
                    Text(
                      doc['selectedTimeSlot'].toString(),
                    ),*/
                    const SizedBox(
                      height: 5,
                    )
                  ],
                );
              },
            );
          }),
    );
  }
}
