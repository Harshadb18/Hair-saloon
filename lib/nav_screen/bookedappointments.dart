import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salon_client/nav_screen/account/historylist2.dart';

class BookedAppointment extends StatefulWidget {
  const BookedAppointment({super.key});

  @override
  State<BookedAppointment> createState() => _BookedAppointmentState();
}

class _BookedAppointmentState extends State<BookedAppointment> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String? currentUserId;
  DateTime today = DateTime.now();
  late String formattedToday;

  @override
  void initState() {
    super.initState();
    formattedToday =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Scheduled Appointments'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('bookings')
              .where('bookingDate', isGreaterThanOrEqualTo: formattedToday)
              .where('complete', isEqualTo: '0')
              .where('bookingDate', isGreaterThan: Timestamp.fromDate(DateTime.now())) // Add this line to filter out past time slots
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No data available.'));
            }

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
