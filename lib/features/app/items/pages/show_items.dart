import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_demo/global/common/toast.dart';

class ShowItems extends StatefulWidget {
  const ShowItems({super.key});

   @override
  State<ShowItems> createState() => _ShowItemsState();
}

class _ShowItemsState extends State<ShowItems> {
  final User? user = FirebaseAuth.instance.currentUser;
  List allData = [];
  late List<bool> _selected;
  // final List<bool> _selected = List.generate(21, (i) => false);

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   getData();
  //   _selected = List.generate(allData.length, (i) => false);
  // }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    const items = 11;
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
        title: Text('Browse Items'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
            children: List.generate(
            allData.length, (index) =>
            ListTile(
              title: Text(
                allData[index]['name'].toString().toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: const Color.fromRGBO(3, 110, 84, 1))),
              subtitle: Text('Owner: ${allData[index]['ownerEmail']}\nBorrowed By: ${allData[index]['borrowerEmail']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: const Color.fromARGB(255, 5, 5, 5) )),
              // trailing: Icon(Icons.chevron_right),
              trailing: IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  _borrowItem(allData[index]);
                },
              ),
              leading: Icon(
                Icons.inventory_rounded,
                color: Colors.blue,
                size: 30.0,
              ),
              textColor: Colors.black,
              selected: _selected[index],
              selectedTileColor: Colors.lightGreen,
              enabled: true,
              // dense: true,
              // visualDensity: VisualDensity.compact,
              // isThreeLine: true,
              onTap: () => setState(() {
                for (int i=0; i < _selected.length; i++) {
                  if (i != index){
                    _selected[i] = false;
                  }
                }
                _selected[index] = !_selected[index];
              })
            ),
          )
      ),
    );
  }

  Future<void> getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('items').get();
    setState(() {
      allData = querySnapshot.docs.map((doc) {
        final newDoc = doc.data() as Map<String, dynamic>;
        newDoc['id'] = doc.id;
        return newDoc;
      }).toList();
      _selected = List.generate(allData.length, (i) => false);
    });
  }

  void _borrowItem(final item) {
    print(item);

    if(item['borrowed_by'] != null){
      if(item['borrowed_by'] == user!.uid){
        showToast(
          message: 'You are already using this item.',
          backgroundColor: Colors.pink.shade300);
      }else{
        showToast(
          message: 'It is being used by some one else, can not be borrowed.',
          backgroundColor: Colors.pink.shade300);
      }
    }else{
      if(item['ownerEmail'] == user!.email){
        showToast(
          message: 'You are owner, can not be borrowed.',
          backgroundColor: Colors.pink.shade300);
      }else{
        FirebaseFirestore.instance.collection('items').doc(item['id']).update({
          'borrowed_by': user!.uid,
          'borrowerEmail': user!.email,
        });
        showToast(
          message: 'You borrowed this item...',
          backgroundColor: Colors.green);
        _selected = List.generate(allData.length, (i) => false);
        getData();
      }
    }
  }
}
