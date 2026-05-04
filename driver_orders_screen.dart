import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';
import 'firebase_service.dart';

class DriverOrdersScreen extends StatefulWidget {
  final String driverUid;
  final String driverCity;

  const DriverOrdersScreen({super.key, required this.driverUid, required this.driverCity});

  @override
  State<DriverOrdersScreen> createState() => _DriverOrdersScreenState();
}

class _DriverOrdersScreenState extends State<DriverOrdersScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('داواکارییەکانی شۆفێر'),
        actions: [
          Switch(
            value: _isActive,
            onChanged: (value) {
              setState(() {
                _isActive = value;
              });
              // Update isActive status in Firestore
              FirebaseFirestore.instance
                  .collection('drivers')
                  .doc(widget.driverUid)
                  .update({'isActive': value});
            },
          ),
        ],
      ),
      body: !_isActive
          ? const Center(child: Text('تکایە خۆت ئەکتیڤ بکە بۆ بینینی داواکارییەکان'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('rides')
                  .where('status', isEqualTo: 'pending')
                  .where('originCity', isEqualTo: widget.driverCity)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text('هەڵەیەک ڕوویدا'));
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                if (docs.isEmpty) return const Center(child: Text('هیچ داواکارییەک نییە لە ئێستادا'));

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final ride = RideRequest.fromFirestore(docs[index]);
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('لە: ${ride.originCity} بۆ: ${ride.destinationCity}'),
                        subtitle: Text('نرخ: ${ride.fare} دینار'),
                        trailing: ElevatedButton(
                          onPressed: () => _acceptRide(ride.id),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: const Text('Accept', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void _acceptRide(String rideId) async {
    try {
      await _firebaseService.acceptRide(widget.driverUid, rideId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('داواکارییەکە بە سەرکەوتوویی وەرگیرا')),
        );
        // Navigate to Active Ride Screen (to be implemented)
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('هەڵە: ${e.toString()}')),
        );
      }
    }
  }
}
