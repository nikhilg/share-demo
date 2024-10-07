import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ItemEntryScreen extends StatefulWidget {
  const ItemEntryScreen({super.key});

  @override
  _ItemEntryScreenState createState() => _ItemEntryScreenState();
}

class _ItemEntryScreenState extends State<ItemEntryScreen> {
  final TextEditingController _itemController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Items')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _itemController,
              decoration: const InputDecoration(labelText: 'Enter Item Name'),
            ),
            ElevatedButton(
              onPressed: () => _addItem(),
              child: const Text('Add Item'),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('items')
                    .where('owner', isEqualTo: user!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData) return const Text('No items found');
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(doc['name']),
                        subtitle: Text('Owner: ${doc['owner']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () => _borrowItem(doc.id),
                        ),
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

  void _addItem() {
    FirebaseFirestore.instance.collection('items').add({
      'name': _itemController.text,
      'owner': user!.uid,
      'borrowed_by': null,
    });
    _itemController.clear();
  }

  void _borrowItem(String itemId) {
    FirebaseFirestore.instance.collection('items').doc(itemId).update({
      'borrowed_by': user!.uid,
    });
  }
}
