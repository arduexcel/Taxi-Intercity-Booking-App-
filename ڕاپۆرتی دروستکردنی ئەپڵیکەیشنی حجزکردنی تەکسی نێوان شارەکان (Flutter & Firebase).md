# ڕاپۆرتی دروستکردنی ئەپڵیکەیشنی حجزکردنی تەکسی نێوان شارەکان (Flutter & Firebase)

ئەم ڕاپۆرتە وردەکارییەکانی دروستکردنی ئەپڵیکەیشنی حجزکردنی تەکسی نێوان شارەکان بە Flutter و Firebase دەخاتە ڕوو. ئەپڵیکەیشنەکە سێ جۆر بەکارهێنەری سەرەکی دەگرێتەوە: سەرنشین (Passenger)، شۆفێر (Driver)، و کۆمپانیا/ئەدمن (Admin). ئەم بەشە سەرەکییانە داڕشتنی ستراکچەری داتابەیسی Firebase Firestore، مۆدێلەکانی Flutter، سێرڤیسەکانی Firebase، و کۆدی سەرەتایی بۆ لاپەڕەی داواکارییەکانی شۆفێر و ڕووکاری ئەدمن دەگرێتەوە.

## 1. ستراکچەری داتابەیسی Firebase Firestore

ستراکچەری داتابەیسەکە بە شێوەیەک داڕێژراوە کە پشتگیری لە پێداویستییەکانی سێ جۆر بەکارهێنەرەکە بکات و کارایی بەرز بێت لە گەڕان و مامەڵەکاندا. خشتەی خوارەوە کۆلێکشنە سەرەکییەکان و فێڵدەکانیان ڕوون دەکاتەوە:

### 1.1. کۆلێکشنی `users`

ئەم کۆلێکشنە زانیاری گشتی بەکارهێنەران هەڵدەگرێت و وەک خاڵێکی ناوەندی بۆ ناساندن و زانیاری سەرەتایی پرۆفایل خزمەت دەکات.

| Field Name | Data Type | Description |
| :--------- | :-------- | :---------- |
| `uid`      | String    | ناسنامەی ناوازەی بەکارهێنەر (لە Firebase Authentication) |
| `name`     | String    | ناوی تەواوی بەکارهێنەر |
| `phone`    | String    | ژمارەی مۆبایلی بەکارهێنەر (ناوازە) |
| `role`     | String    | ڕۆڵی بەکارهێنەر: `passenger`، `driver`، یان `admin` |
| `balance`  | Number    | باڵانسی ئێستای بەکارهێنەر (بۆ نموونە، بە دینار) |
| `createdAt`| Timestamp | کاتی دروستبوونی بەکارهێنەر |
| `updatedAt`| Timestamp | کاتی نوێکردنەوەی کۆتایی |

### 1.2. کۆلێکشنی `passengers`

ئەم کۆلێکشنە وردەکاری تایبەت بە سەرنشینەکان هەڵدەگرێت، کە بە ناسنامەی بەکارهێنەرەکەیان لە کۆلێکشنی `users` بەستراوەتەوە.

| Field Name | Data Type | Description |
| :--------- | :-------- | :---------- |
| `uid`      | String    | ناسنامەی ناوازەی بەکارهێنەر (ئاماژە بە `users.uid`) |
| `homeLocation` | GeoPoint  | شوێنی سەرەکی (ماڵ) بۆ سەرنشین |
| `homeLocationName` | String | ناوی شوێنی سەرەکی |

### 1.3. کۆلێکشنی `drivers`

ئەم کۆلێکشنە وردەکاری تایبەت بە شۆفێرەکان هەڵدەگرێت، کە بە ناسنامەی بەکارهێنەرەکەیان لە کۆلێکشنی `users` بەستراوەتەوە.

| Field Name | Data Type | Description |
| :--------- | :-------- | :---------- |
| `uid`      | String    | ناسنامەی ناوازەی بەکارهێنەر (ئاماژە بە `users.uid`) |
| `city`     | String    | ئەو شارەی شۆفێرەکە تێیدا کار دەکات |
| `isActive` | Boolean   | ستاتوسێک کە دیاری دەکات ئایا شۆفێرەکە چالاکە و بەردەستە بۆ گەشت |
| `carModel` | String    | مۆدێلی ئۆتۆمبێلی شۆفێر |
| `carPlate` | String    | ژمارەی تابلۆی ئۆتۆمبێلی شۆفێر |

### 1.4. کۆلێکشنی `rides`

ئەم کۆلێکشنە وردەکارییەکانی هەر داواکارییەکی حجزکردنی تەکسی هەڵدەگرێت. ئەمە کۆلێکشنێکی گرنگە بۆ بەڕێوەبردنی سووڕی ژیانی گەشتەکە.

| Field Name | Data Type | Description |
| :--------- | :-------- | :---------- |
| `rideId`   | String    | ناسنامەی ناوازە بۆ گەشتەکە |
| `passengerUid` | String | ناسنامەی سەرنشین کە داواکاری گەشتەکەی کردووە (ئاماژە بە `users.uid`) |
| `driverUid`| String    | ناسنامەی شۆفێر کە گەشتەکەی وەرگرتووە (ئاماژە بە `users.uid`). Null دەبێت ئەگەر هێشتا وەرنەگیرابێت. |
| `originCity` | String  | ئەو شارەی گەشتەکەی لێوە دەست پێدەکات |
| `destinationCity` | String | ئەو شارەی گەشتەکەی بۆی دەچێت |
| `pickupLocation` | GeoPoint | شوێنی وەرگرتنی سەرنشین |
| `pickupLocationName` | String | ناوی شوێنی وەرگرتن |
| `dropoffLocation` | GeoPoint | شوێنی دابەزینی سەرنشین |
| `dropoffLocationName` | String | ناوی شوێنی دابەزین |
| `status`   | String    | ستاتوسی ئێستای گەشتەکە: `pending`، `accepted`، `cancelled_by_passenger`، `cancelled_by_driver`، `completed` |
| `fare`     | Number    | نرخی گشتی گەشتەکە |
| `passengerDeduction` | Number | بڕی پارەی بڕدراو لە باڵانسی سەرنشین (500 دینار) |
| `driverDeduction` | Number | بڕی پارەی بڕدراو لە باڵانسی شۆفێر (2000 دینار) |
| `requestedAt`| Timestamp | کاتی داواکردنی گەشتەکە |
| `acceptedAt` | Timestamp | کاتی وەرگرتنی گەشتەکە لەلایەن شۆفێرەوە |
| `completedAt`| Timestamp | کاتی تەواوبوونی گەشتەکە |

### 1.5. کۆلێکشنی `cities`

ئەم کۆلێکشنە لیستی شارە بەردەستەکان بۆ گەشتی نێوان شارەکان هەڵدەگرێت.

| Field Name | Data Type | Description |
| :--------- | :-------- | :---------- |
| `name`     | String    | ناوی شارەکە (بۆ نموونە، 'هەولێر'، 'سلێمانی') |

### 1.6. کۆلێکشنی `settings` (یەک دۆکیومێنت)

ئەم کۆلێکشنە یەک دۆکیومێنتی تێدایە بۆ ڕێکخستنەکانی گشتی ئەپڵیکەیشنەکە، وەک نرخەکان.

| Field Name | Data Type | Description |
| :--------- | :-------- | :---------- |
| `passengerCancellationFee` | Number | بڕی پارەی بڕدراو لە سەرنشین بۆ هەڵوەشاندنەوە (بۆ نموونە، 500) |
| `driverAcceptanceFee` | Number | بڕی پارەی بڕدراو لە شۆفێر بۆ وەرگرتنی گەشتێک (بۆ نموونە، 2000) |
| `baseFarePerKm` | Number | نرخی بنەڕەتی بۆ هەر کیلۆمەترێک |
| `intercitySurcharge` | Number | تێچووی زیادە بۆ گەشتی نێوان شارەکان |

## 2. مۆدێلەکانی Flutter

ئەم کۆدانە مۆدێلەکانی داتا بۆ بەکارهێنەر (AppUser)، شۆفێر (Driver)، و داواکاری گەشت (RideRequest) لە Flutter نیشان دەدەن، کە یارمەتیدەرن بۆ مامەڵەکردن لەگەڵ داتاکانی Firestore.

```dart
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
```

## 3. سێرڤیسەکانی Firebase (مامەڵەکان)

ئەم کۆدە سێرڤیسێکی Firebase نیشان دەدات کە مامەڵەکان (Transactions) بەکاردەهێنێت بۆ دڵنیابوون لە یەکپارچەیی داتا لە کاتی داواکردن و وەرگرتنی گەشتەکان. ئەمە زۆر گرنگە بۆ ڕێگریکردن لە کێشەکانی وەک وەرگرتنی یەک گەشت لەلایەن چەند شۆفێرێکەوە.

```dart
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
```

## 4. کۆدی سەرەتایی لاپەڕەی وەرگرتنی داواکاری بۆ شۆفێر (Driver Orders Screen)

ئەم کۆدە لاپەڕەی سەرەتایی بۆ شۆفێرەکان نیشان دەدات، کە تێیدا دەتوانن داواکارییە چاوەڕوانکراوەکانی گەشت ببینن و وەریانبگرن. فلتەرکردن بەپێی شار و ستاتوسی چالاکی شۆفێرەکە جێبەجێ کراوە.

```dart
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
```

## 5. کۆدی سەرەتایی ڕووکاری کۆمپانیا (Admin Panel Screen)

ئەم کۆدە لاپەڕەی سەرەتایی بۆ بەڕێوەبەر (Admin) نیشان دەدات، کە تێیدا دەتوانێت باڵانس بۆ بەکارهێنەران زیاد بکات و ئاماری گەشتەکان ببینێت.

```dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ڕووکاری کۆمپانیا (Admin)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('زیادکردنی باڵانس بۆ بەکارهێنەر', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'ژمارەی مۆبایل', border: OutlineInputBorder()),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'بڕی پارە (دینار)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addBalance,
                child: const Text('زیادکردن'),
              ),
            ),
            const Divider(height: 40),
            const Text('ئاماری گەشتەکان', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('rides').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final rides = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: rides.length,
                    itemBuilder: (context, index) {
                      final ride = rides[index].data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text('${ride['originCity']} -> ${ride['destinationCity']}'),
                        subtitle: Text('Status: ${ride['status']} | Fare: ${ride['fare']}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addBalance() async {
    String phone = _phoneController.text.trim();
    double amount = double.tryParse(_amountController.text) ?? 0;

    if (phone.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تکایە زانیارییەکان بە دروستی پڕ بکەرەوە')));
      return;
    }

    try {
      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('بەکارهێنەر نەدۆزرایەوە')));
        return;
      }

      final userDoc = userQuery.docs.first;
      await userDoc.reference.update({
        'balance': FieldValue.increment(amount),
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('باڵانس بە سەرکەوتوویی زیادکرا')));
      _phoneController.clear();
      _amountController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('هەڵە: ${e.toString()}')));
    }
  }
}
```

## 6. تێبینی تەکنیکی گرنگ

*   **Firebase Firestore:** وەک داتابەیسی سەرەکی بەکارهاتووە بەهۆی توانای ڕاستەوخۆ (real-time) و مامەڵە پارێزراوەکانی. [1]
*   **Transactions:** بەکارهێنانی `runTransaction` لە Firebase زۆر گرنگە بۆ دڵنیابوون لەوەی کە تەنها یەک شۆفێر دەتوانێت یەک داواکاری گەشت وەربگرێت لە یەک کاتدا، ئەمەش ڕێگری دەکات لە کێشەکانی هاوکاتبوون (concurrency issues). [2]
*   **City-based Filtering:** داواکارییەکان بۆ شۆفێرەکان بەپێی شار فلتەر دەکرێن، ئەمەش دڵنیا دەبێتەوە کە شۆفێرەکان تەنها ئەو گەشتانە دەبینن کە لە شارەکەی خۆیانن.
*   **Balance Management:** سیستەمی باڵانس بۆ سەرنشین و شۆفێر جێبەجێ کراوە، لەگەڵ بڕینی پارە لە کاتی داواکردن و وەرگرتنی گەشت، و گەڕاندنەوەی پارە لە کاتی هەڵوەشاندنەوە.

## 7. هەنگاوەکانی داهاتوو

*   جێبەجێکردنی لاپەڕەی سەرنشین بۆ داواکردنی گەشت و بینینی ستاتوسی گەشتەکان.
*   تەواوکردنی ڕووکاری ئەدمن بۆ کۆنترۆڵکردنی نرخەکان و بینینی ئاماری گەشتەکان بە شێوەیەکی گشتگیرتر.
*   زیادکردنی سیستەمی Authentication (ناونووسین و چوونەژوورەوە) بە Firebase Auth.
*   جێبەجێکردنی نەخشە (Map) بۆ دیاریکردنی شوێنی وەرگرتن و گەیشتن.
*   زیادکردنی ئاگادارکەرەوەکان (Notifications) بۆ شۆفێر و سەرنشین.

## 8. سەرچاوەکان

[1] Firebase Firestore Documentation. (n.d.). Retrieved from [https://firebase.google.com/docs/firestore](https://firebase.google.com/docs/firestore)
[2] Firebase Transactions. (n.d.). Retrieved from [https://firebase.google.com/docs/firestore/manage-data/transactions](https://firebase.google.com/docs/firestore/manage-data/transactions)
