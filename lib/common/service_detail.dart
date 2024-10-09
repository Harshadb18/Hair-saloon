import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salon_client/common/detail.dart';
import 'package:salon_client/utils/service_box.dart';

class ServiceList extends StatelessWidget {
  final String category, section;
  const ServiceList(this.category, this.section, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('services')
          .where('category', isEqualTo: category)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data available.'));
        }

        final documents = snapshot.data!.docs;
        final data = documents.where((doc) => doc['section'].contains(section)).toList();

        if (data.isEmpty) {
          return const Center(child: Text('No data available.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final doc = data[index];

            return Column(
              children: [
                ServiceDisplay(
                  doc['name'],
                  doc['section'],
                  doc['imageUrl'],
                  doc['price'],
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          name: doc['name'],
                          section: doc['section'],
                          category: doc['category'],
                          description: doc['description'],
                          imageUrl: doc['imageUrl'],
                          price: doc['price'],
                          id: doc.id,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        );
      },
    );
  }
}
