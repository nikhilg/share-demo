import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController _itemController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 50.0,
        color: const Color.fromARGB(255, 36, 152, 187),
        child: ListTile(
          leading: Icon(Icons.account_circle_rounded, color: Colors.white),
          title: Text( user!.email ?? '', style: TextStyle(fontWeight: FontWeight.bold), ),
        )
      ),
      appBar: AppBar(
        title: Text('My Items'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _itemController,
              decoration: InputDecoration(labelText: 'Enter Item Name'),
            ),
            ElevatedButton(
              onPressed: () => _addItem(),
              child: Text('Add Item'),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                  .collection('items')
                  .where('owner', isEqualTo: user!.uid)
                  .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (!snapshot.hasData) return Text('No items found');
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(doc['name'].toString().toUpperCase()),
                        subtitle: Text('Owner: ${doc['ownerEmail']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () => {},
                          // onPressed: () => _borrowItem(doc.id),
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
      'ownerEmail': user!.email,
      'borrowed_by': null,
    });
    _itemController.clear();
  }

  void _borrowItem(String itemId) {
    FirebaseFirestore.instance.collection('items').doc(itemId).update({
      'borrowed_by': user!.uid,
      'borrowerEmail': user!.email,
    });
  }
}
