import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String name;
  final String phone;
  final String role;
  final double balance;

  AppUser({
    required this.uid,
    required this.name,
    required this.phone,
    required this.role,
    required this.balance,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? 'passenger',
      balance: (data['balance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'role': role,
      'balance': balance,
    };
  }
}

class Driver {
  final String uid;
  final String city;
  final bool isActive;

  Driver({
    required this.uid,
    required this.city,
    required this.isActive,
  });

  factory Driver.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Driver(
      uid: doc.id,
      city: data['city'] ?? '',
      isActive: data['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'isActive': isActive,
    };
  }
}

class RideRequest {
  final String id;
  final String passengerUid;
  final String? driverUid;
  final String originCity;
  final String destinationCity;
  final String status;
  final double fare;
  final Timestamp requestedAt;

  RideRequest({
    required this.id,
    required this.passengerUid,
    this.driverUid,
    required this.originCity,
    required this.destinationCity,
    required this.status,
    required this.fare,
    required this.requestedAt,
  });

  factory RideRequest.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return RideRequest(
      id: doc.id,
      passengerUid: data['passengerUid'] ?? '',
      driverUid: data['driverUid'],
      originCity: data['originCity'] ?? '',
      destinationCity: data['destinationCity'] ?? '',
      status: data['status'] ?? 'pending',
      fare: (data['fare'] ?? 0).toDouble(),
      requestedAt: data['requestedAt'] ?? Timestamp.now(),
    );
  }
}
