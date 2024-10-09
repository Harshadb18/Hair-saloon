import 'package:flutter/material.dart';

class HistoryContainer extends StatelessWidget {
  final String date;
  final String time;
  final String servicename;
  final String category;
  final String imgUrl;
  final String price;
  const HistoryContainer(this.date, this.time, this.servicename, this.category,
      this.imgUrl, this.price,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      //padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          border: Border.all(width: 0.7),
          boxShadow: const [
            BoxShadow(color: Colors.grey, offset: Offset(4, 4))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SizedBox(height: 10),
          Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: Image.network(
                imgUrl,
                height: 250,
                width: 250,
              )),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Service Name :",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(servicename)
            ],
          ),
          //Text("Service Name : $servicename"),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Category :",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(category)
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Appointment date:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(date)
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Scheduled time:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(time)
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Amount ( Rs ):",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(price)
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
