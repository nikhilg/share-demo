import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BorrowedItemsScreen extends StatelessWidget {
  const BorrowedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

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
        title: Text('Borrowed Items'),
        backgroundColor: Colors.blueGrey,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('items')
            .where('borrowed_by', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (!snapshot.hasData) return Text('No items borrowed');
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return ListTile(
                title: Text(
                  doc['name'].toString().toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: const Color.fromRGBO(3, 110, 84, 1))),
                subtitle: Text('Borrowed from: ${doc['ownerEmail']}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: const Color.fromARGB(255, 54, 82, 244) )),
                trailing: Icon(Icons.chevron_right),
                leading: Icon(
                  Icons.inventory_rounded,
                  color: const Color.fromARGB(255, 153, 28, 28),
                  size: 30.0,
                ),
                textColor: Colors.black,
              );
            },
          );
        },
      ),
    );
  }
}
