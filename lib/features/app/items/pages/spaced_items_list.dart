import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SpacedItemsList extends StatelessWidget {
  const SpacedItemsList({super.key});
  static List allData = [];
  Future<void> getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('items').get();
    allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    const items = 11;
    getData();
    // final items = FirebaseFirestore.instance.collection('items');
    // final ss = items.count().get();
    // final count = ss.asStream().length;
    return Scaffold(
      bottomNavigationBar: Container(
        height: 40.0,
        color: Colors.red,
      ),
      // bottomSheet: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: [
      //       SizedBox(
      //         height: 70,
      //         child: Text("Footer", style: TextStyle(
      //                     color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 25),),
      //       ),
      // ], ),
      appBar: AppBar(
        title: Text('Browse Items'),
        backgroundColor: Colors.blueGrey,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
            //     children: <Widget>[
            //       Expanded(
            //         child: SizedBox(
            //           height: 200,
            //           child: StreamBuilder(
            //             stream: FirebaseFirestore.instance
            //               .collection('items')
            //               .where('borrowed_by', isNull: true )
            //               .snapshots(),
            //             builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //               if (snapshot.connectionState == ConnectionState.waiting) {
            //                 return CircularProgressIndicator();
            //               }
            //               if (!snapshot.hasData) return Text('No items found');
            //               return ListView.builder(
            //                 scrollDirection: Axis.vertical,
            //                 itemCount: snapshot.data!.docs.length,
            //                 itemBuilder: (context, index) {
            //                   var doc = snapshot.data!.docs[index];
            //                   return ItemWidget(text: doc.get('name'));
            //                   // return ListTile(
            //                   //   title: Text(doc['name']),
            //                   //   subtitle: Text('Owner: ${doc['owner']}'),
            //                   //   trailing: IconButton(
            //                   //     icon: Icon(Icons.share),
            //                   //     onPressed: () => _borrowItem(doc.id),
            //                   //   ),
            //                   // );
            //                 },
            //               );
            //             },
            //           ),
            //         ),
            //       ),
            // ]
              children: List.generate(
                  allData.length, (index) =>
                    // final name = allData[index];
                    ItemWidget(name: allData[index]['name'], owner: allData[index]['owner'])
                    ),
            ),
          ),
        );
      }),
    );
  }
}

class ItemWidget extends StatelessWidget {
  final String name;
  final String owner;
  const ItemWidget({
    super.key,
    required this.name,
    required this.owner,
  });


  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.inventory,
                color: Colors.green,
                size: 36.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // StreamBuilder(
                  //   stream: FirebaseFirestore.instance
                  //     .collection('items')
                  //     .snapshots(),
                  //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return CircularProgressIndicator();
                  //     }
                  //     if (!snapshot.hasData) return Text('No items found');
                  //     return ListView.builder(
                  //       itemCount: snapshot.data!.docs.length,
                  //       itemBuilder: (context, index) {
                  //         var doc = snapshot.data!.docs[index];
                  //         return ListTile(
                  //           title: Text(doc['name']),
                  //           subtitle: Text('Owner: ${doc['owner']}'),
                            // trailing: IconButton(
                            //   icon: Icon(Icons.share),
                            //   onPressed: () => _borrowItem(doc.id),
                            // ),
                  //         );
                  //       },
                  //     );
                  //   },
                  // ),
                  // ListTile(
                  //   title: Text(name)
                  // ),
                  ListTile(
                    title: Text(name),
                    subtitle: Text(owner),
                  )
                  // Icon(
                  //   Icons.beach_access,
                  //   color: Colors.blue,
                  //   size: 36.0,
                  // ),
                  // Icon(
                  //   Icons.local_activity,
                  //   color: Colors.yellow,
                  //   size: 36.0,
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
