import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BorrowedItemsScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  BorrowedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Borrowed Items')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('items')
            .where('borrowed_by', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (!snapshot.hasData) return const Text('No items borrowed');
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return ListTile(
                title: Text(doc['name']),
                subtitle: Text('Borrowed from: ${doc['owner']}'),
              );
            },
          );
        },
      ),
    );
  }
}
