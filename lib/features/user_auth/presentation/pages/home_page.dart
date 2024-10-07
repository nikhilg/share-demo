import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_demo/global/common/toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          automaticallyImplyLeading: false,
          title: Text("HomePage"),
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
        ),
        // body: Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        body: GridView.count(crossAxisCount: 2,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/showItems");
                  },
                  child: Container(
                    height: 45,
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 92, 150, 81),
                      borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "Inventory",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/addItems");
                  },
                  child: Container(
                    height: 45,
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 92, 150, 81),
                      borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "Add Items",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/borrowedItems");
                  },
                  child: Container(
                    height: 45,
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 92, 150, 81),
                      borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "Borrowed Items",
                          style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 10),
              // GestureDetector(
              //   onTap: () {
              //     _createData(UserModel(
              //       username: "Henry",
              //       age: 21,
              //       adress: "London",
              //     ));
              //   },
              //   child: Container(
              //     height: 45,
              //     width: 100,
              //     decoration: BoxDecoration(
              //       color: Colors.blue,
              //       borderRadius: BorderRadius.circular(10)),
              //     child: Center(
              //       child: Text(
              //         "Create Data",
              //         style: TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 18),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 10),
              // StreamBuilder<List<UserModel>>(
              // stream: _readData(),
              // builder: (context, snapshot) {
              //   if (snapshot.connectionState == ConnectionState.waiting) {
              //     return Center(
              //       child: CircularProgressIndicator(),
              //     );
              //   }
              //   if (snapshot.data!.isEmpty) {
              //     return Center(child: Text("No Data Yet"));
              //   }
              //   final users = snapshot.data;
              //   return Padding(
              //     padding: EdgeInsets.all(8),
              //     child: Column(
              //         children: users!.map((user) {
              //       return ListTile(
              //         leading: GestureDetector(
              //           onTap: () {
              //             _deleteData(user.id!);
              //           },
              //           child: Icon(Icons.delete),
              //         ),
              //         trailing: GestureDetector(
              //           onTap: () {
              //             _updateData(UserModel(
              //               id: user.id,
              //               username: "John Wick",
              //               adress: "Pakistan",
              //             ));
              //           },
              //           child: Icon(Icons.update),
              //         ),
              //         title: Text(user.username!),
              //         subtitle: Text(user.adress!),
              //       );
              //     }).toList()),
              //   );
              // }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, "/login");
                    showToast(message: "Successfully signed out");
                  },
                  child: Container(
                    height: 45,
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 92, 150, 81),
                      borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "Sign out",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        // )
      );
  }

  Stream<List<UserModel>> _readData() {
    final userCollection = FirebaseFirestore.instance.collection("users");

    return userCollection.snapshots().map((qureySnapshot) => qureySnapshot.docs
        .map(
          (e) => UserModel.fromSnapshot(e),
        )
        .toList());
  }

  void _createData(UserModel userModel) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    String id = userCollection.doc().id;

    final newUser = UserModel(
      username: userModel.username,
      age: userModel.age,
      adress: userModel.adress,
      id: id,
    ).toJson();

    userCollection.doc(id).set(newUser);
  }

  void _updateData(UserModel userModel) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final newData = UserModel(
      username: userModel.username,
      id: userModel.id,
      adress: userModel.adress,
      age: userModel.age,
    ).toJson();

    userCollection.doc(userModel.id).update(newData);
  }

  void _deleteData(String id) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    userCollection.doc(id).delete();
  }
}

class UserModel {
  final String? username;
  final String? adress;
  final int? age;
  final String? id;

  UserModel({this.id, this.username, this.adress, this.age});

  static UserModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(
      username: snapshot['username'],
      adress: snapshot['adress'],
      age: snapshot['age'],
      id: snapshot['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "age": age,
      "id": id,
      "adress": adress,
    };
  }
}
