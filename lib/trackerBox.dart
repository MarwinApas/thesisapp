import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackerBox extends StatefulWidget {
  final String boxName;
  final VoidCallback onDelete;

  const TrackerBox({Key? key, required this.boxName, required this.onDelete})
      : super(key: key);

  @override
  _TrackerBoxState createState() => _TrackerBoxState();
}

class _TrackerBoxState extends State<TrackerBox> {
  bool _expanded = false;
  late String userName; // Define userKey variable

  @override
  void initState() {
    super.initState();
    // Fetch userKey based on username when the widget is initialized
    GetUserName().then((username) {
      setState(() {
        userName = username ?? ''; // Assign the fetched userKey or an empty string if null
      });
    });
  }


  Future<String?> GetUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  Future<void> _deleteAndShowSnackBar(String kioskName) async {
    // Delete the widget
    widget.onDelete();
    // Remove the corresponding kioskName from the database
    DatabaseReference kiosksRef = FirebaseDatabase.instance.ref().child('owners_collection')
        .child(userName)
        .child('kiosks')
        .child(kioskName);
    await kiosksRef.remove();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        setState(() {
          _expanded = !_expanded; // Toggle expanded state
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: _expanded ? 250 : 80, // Set expanded and default heights
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Container(
              height: _expanded ? 590 : 80, // Adjust the height as needed
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
                        widget.boxName,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Conditionally show the content based on expanded state
                  if (_expanded)
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FutureBuilder<DatabaseEvent>(
                              future: FirebaseDatabase.instance
                                  .ref()
                                  .child('Denomination')
                                  .once(),
                              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text("Error: ${snapshot.error}");
                                } else if (!snapshot.hasData) {
                                  return Text("No data available");
                                } else {
                                  DataSnapshot dataSnapshot = snapshot.data!.snapshot;
                                  Map<dynamic, dynamic> denominationsData = dataSnapshot.value as Map<dynamic, dynamic>;
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
                // Directly delete without confirmation dialog
                await _deleteAndShowSnackBar(widget.boxName); // Pass boxName here
              },
            ),
          ],
        ),
      ),
    );
  }
}
