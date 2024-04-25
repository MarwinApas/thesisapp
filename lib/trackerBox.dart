import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_database/firebase_database.dart';

class TrackerBox extends StatelessWidget {
  final String boxName;
  final VoidCallback onDelete;
  const TrackerBox({Key? key, required this.boxName, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    Future<void> _deleteAndShowSnackBar() async {
      // Delete the widget
      onDelete();

      // Decrement 'kiosk' value in Firebase
      DatabaseReference _kioskRef =
      FirebaseDatabase.instance.reference().child('kiosk');
      DataSnapshot snapshot = (await _kioskRef.once()).snapshot;
      int currentKiosk = snapshot.value as int;
      if (currentKiosk > 0) {
        _kioskRef.set(currentKiosk - 1); // Decrement 'kiosk' by 1
      }

      // Show a SnackBar indicating item deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tracker deleted'),
        ),
      );
    }

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 1 / 5,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Container(
          height: 170,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(
              color: Color(0xFFD96C00),
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 0),
                  child: Text(
                    'KIOSK',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder<DatabaseEvent>(
                        future: FirebaseDatabase.instance
                            .reference()
                            .child('Denomination')
                            .once() as Future<DatabaseEvent>?,
                        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else if (!snapshot.hasData) {
                            return Text("No data available");
                          } else {
                            DataSnapshot dataSnapshot = snapshot.data!.snapshot;
                            Map<dynamic, dynamic> denominationsData =
                            dataSnapshot.value as Map<dynamic, dynamic>;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "PESO STACK:",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "1000-PESO BILL STACK: ${denominationsData['1000']}",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "100-PESO BILL STACK: ${denominationsData['100']}",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "20-PESO COIN STACK: ${denominationsData['20']}",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "5-PESO COIN STACK: ${denominationsData['5']}",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "1-PESO COIN STACK: ${denominationsData['1']}",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            // Show a dialog with "Yes" or "No" options
            bool confirmDelete = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Deletion'),
                  content: Text('Are you sure you want to delete this KIOSK? (UNDO IS CURRENTLY NOT SUPPORTED)'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // Return false if "No" is pressed
                      },
                      child: Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true); // Return true if "Yes" is pressed
                      },
                      child: Text('Yes'),
                    ),
                  ],
                );
              },
            );

            // If "Yes" is pressed, proceed with deletion
            if (confirmDelete == true) {
              await _deleteAndShowSnackBar();
            }
          },
        ),
      ],
    );
  }
}