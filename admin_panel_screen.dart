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
