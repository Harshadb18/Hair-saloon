import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentBookingWidget extends StatefulWidget {
  final String hairstyleId;

  const AppointmentBookingWidget({super.key, required this.hairstyleId});

  @override
  _AppointmentBookingWidgetState createState() =>
      _AppointmentBookingWidgetState();
}

class _AppointmentBookingWidgetState extends State<AppointmentBookingWidget> {
  DateTime _selectedDay = DateTime.now();
  final List<String> _timeSlots = [];
  List<String> _bookedTimeSlots = [];
  late String _selectedHairstyle;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _selectedHairstyle = widget.hairstyleId;
    _fetchBookedTimeSlots();
  }

  void generateTimeSlots() {
    _timeSlots.clear();
    for (int hour = 10; hour <= 21; hour++) {
      _timeSlots.add('$hour:00 - ${hour + 1}:00');
    }
  }

  Future<void> _fetchBookedTimeSlots() async {
    String formattedDate =
        "${_selectedDay.year}-${_selectedDay.month.toString().padLeft(2, '0')}-${_selectedDay.day.toString().padLeft(2, '0')}";
    QuerySnapshot querySnapshot = await _firestore
        .collection('bookings')
        .where('bookingDate', isEqualTo: formattedDate)
        //.where('selectedHairstyle', isEqualTo: widget.hairstyleId)
        .get();

    setState(() {
      _bookedTimeSlots = querySnapshot.docs
          .map((doc) => doc['selectedTimeSlot'] as String)
          .toList();
    });
  }

  Future<bool> showBookingConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Booking'),
          content: const Text('Do you want to confirm the booking?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleDaySelected(DateTime date, DateTime events) async {
    setState(() {
      _selectedDay = date;
    });
    generateTimeSlots();
    await _fetchBookedTimeSlots();
  }

  Future<void> bookAppointment(String selectedTimeSlot) async {
    try {
      User? user = _auth.currentUser;

      bool bookingConfirmed = await showBookingConfirmationDialog();

      if (bookingConfirmed) {
        await _firestore.collection('bookings').add({
          'userId': user?.uid,
          'selectedHairstyle': _selectedHairstyle,
          'selectedTimeSlot': selectedTimeSlot,
          'bookingDate':
              "${_selectedDay.year}-${_selectedDay.month.toString().padLeft(2, '0')}-${_selectedDay.day.toString().padLeft(2, '0')}",
          'complete': "0",
        });

        _fetchBookedTimeSlots();

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Booking Successful'),
              content: const Text('Your appointment has been booked.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Failed to book appointment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Booking'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime.now().subtract(const Duration(days: 30)),
            lastDay: DateTime.now().add(const Duration(days: 30)),
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.week: 'Week',
            },
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonShowsNext: false,
            ),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            calendarStyle: const CalendarStyle(
                selectedDecoration:
                    BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
            enabledDayPredicate: (day) {
              return !day
                  .isBefore(DateTime.now().subtract(const Duration(days: 1)));
            },
            onDaySelected: (date, events) => _handleDaySelected(date, events),
          ),
          const SizedBox(height: 20),
          const Text(
            'Available Time Slots:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _timeSlots.length,
              itemBuilder: (context, index) {
                bool isBooked = _bookedTimeSlots.contains(_timeSlots[index]);

                return GestureDetector(
                  onTap: isBooked
                      ? null
                      : () => bookAppointment(_timeSlots[index]),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: isBooked ? Colors.red : Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(width: 1)),
                    child: Center(
                      child: Text(
                        _timeSlots[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
