import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. Passenger: Request a Ride
  Future<void> requestRide(String passengerUid, String originCity, String destinationCity, double fare) async {
    final rideRef = _db.collection('rides').doc();
    final userRef = _db.collection('users').doc(passengerUid);

    await _db.runTransaction((transaction) async {
      DocumentSnapshot userSnapshot = await transaction.get(userRef);
      if (!userSnapshot.exists) throw Exception("User does not exist!");

      double currentBalance = (userSnapshot.data() as Map<String, dynamic>)['balance'] ?? 0;
      if (currentBalance < 500) throw Exception("Insufficient balance!");

      // Deduct 500 IQD from passenger
      transaction.update(userRef, {'balance': currentBalance - 500});

      // Create ride request
      transaction.set(rideRef, {
        'passengerUid': passengerUid,
        'originCity': originCity,
        'destinationCity': destinationCity,
        'status': 'pending',
        'fare': fare,
        'passengerDeduction': 500,
        'requestedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // 2. Driver: Accept a Ride (Using Transaction to ensure only one driver accepts)
  Future<void> acceptRide(String driverUid, String rideId) async {
    final rideRef = _db.collection('rides').doc(rideId);
    final driverRef = _db.collection('users').doc(driverUid);

    await _db.runTransaction((transaction) async {
      DocumentSnapshot rideSnapshot = await transaction.get(rideRef);
      DocumentSnapshot driverSnapshot = await transaction.get(driverRef);

      if (!rideSnapshot.exists) throw Exception("Ride does not exist!");
      if ((rideSnapshot.data() as Map<String, dynamic>)['status'] != 'pending') {
        throw Exception("Ride already taken or cancelled!");
      }

      double driverBalance = (driverSnapshot.data() as Map<String, dynamic>)['balance'] ?? 0;

      // Deduct 2000 IQD from driver (even if it goes negative/debt)
      transaction.update(driverRef, {'balance': driverBalance - 2000});

      // Update ride status and assign driver
      transaction.update(rideRef, {
        'driverUid': driverUid,
        'status': 'accepted',
        'driverDeduction': 2000,
        'acceptedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // 3. Driver: Cancel Ride
  Future<void> cancelRideByDriver(String driverUid, String rideId) async {
    final rideRef = _db.collection('rides').doc(rideId);
    final driverRef = _db.collection('users').doc(driverUid);

    await _db.runTransaction((transaction) async {
      DocumentSnapshot rideSnapshot = await transaction.get(rideRef);
      DocumentSnapshot driverSnapshot = await transaction.get(driverRef);

      if ((rideSnapshot.data() as Map<String, dynamic>)['driverUid'] != driverUid) {
        throw Exception("You are not the assigned driver!");
      }

      double driverBalance = (driverSnapshot.data() as Map<String, dynamic>)['balance'] ?? 0;

      // Refund 2000 IQD to driver
      transaction.update(driverRef, {'balance': driverBalance + 2000});

      // Reset ride to pending and remove driver
      transaction.update(rideRef, {
        'driverUid': null,
        'status': 'pending',
        'driverDeduction': 0,
      });
    });
  }

  // 4. Passenger: Cancel Ride
  Future<void> cancelRideByPassenger(String passengerUid, String rideId) async {
    final rideRef = _db.collection('rides').doc(rideId);
    final userRef = _db.collection('users').doc(passengerUid);

    await _db.runTransaction((transaction) async {
      DocumentSnapshot rideSnapshot = await transaction.get(rideRef);
      DocumentSnapshot userSnapshot = await transaction.get(userRef);

      String status = (rideSnapshot.data() as Map<String, dynamic>)['status'];
      String? driverUid = (rideSnapshot.data() as Map<String, dynamic>)['driverUid'];

      double currentBalance = (userSnapshot.data() as Map<String, dynamic>)['balance'] ?? 0;

      // Refund 500 IQD to passenger
      transaction.update(userRef, {'balance': currentBalance + 500});

      // If a driver had accepted, refund them too
      if (driverUid != null) {
        final driverRef = _db.collection('users').doc(driverUid);
        DocumentSnapshot driverSnapshot = await transaction.get(driverRef);
        double driverBalance = (driverSnapshot.data() as Map<String, dynamic>)['balance'] ?? 0;
        transaction.update(driverRef, {'balance': driverBalance + 2000});
      }

      transaction.update(rideRef, {'status': 'cancelled_by_passenger'});
    });
  }

  // 5. Driver: Arrived (Complete Ride)
  Future<void> completeRide(String rideId) async {
    await _db.collection('rides').doc(rideId).update({
      'status': 'completed',
      'completedAt': FieldValue.serverTimestamp(),
    });
  }
}
