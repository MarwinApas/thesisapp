import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thesis_app/WelcomePage.dart';
import 'package:thesis_app/flutter/Alerts.dart';
import 'package:thesis_app/flutter/Settings.dart';
import 'package:thesis_app/trackerBox.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thesis_app/newTrackerBox.dart';
import 'package:thesis_app/SQLite/database_helper.dart';

class Tracker extends StatefulWidget {
  final String? userName;


  const Tracker({Key? key, this.userName}) : super(key: key);

  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  List<String> _trackerBoxes = [];

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xE0FFFFFF),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage(userName: widget.userName)),
            );
          },
        ),
        title: Text(
          'TRACKER',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff02022d),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: ListView.builder(
              itemCount: _trackerBoxes.length,
              itemBuilder: (context, index) {
                return TrackerBox(
                  boxName: _trackerBoxes[index], // Use kiosk name from the list
                  onDelete: () async {
                    bool confirmDelete = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Deletion'),
                          content: Text('Are you sure you want to delete this KIOSK? (UNDO IS CURRENTLY NOT SUPPORTED)'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text('No'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop(true);
                                //await _deleteKiosk(widget.userName!,kioskName);
                              },
                              child: Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );
                    if (confirmDelete == true) {
                      setState(() {
                        _trackerBoxes.removeAt(index);
                      });
                    }
                  },
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 90,
              color: Color(0xff02022d),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomePage(userName: widget.userName)),
                      );
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xE0FFFFFF),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home,
                            size: 30,
                            color: Colors.black,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'HOME',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.radar_sharp,
                          size: 30,
                          color: Colors.white,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'TRACKER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 50),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => Alerts(),
                          transitionsBuilder: (_, animation, __, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: Duration(milliseconds: 100),
                        ),
                      );
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xE0FFFFFF),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notification_important,
                            size: 30,
                            color: Colors.black,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'ALERTS',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => Settings(userName: widget.userName),
                          transitionsBuilder: (_, animation, __, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: Duration(milliseconds: 100),
                        ),
                      );
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0),

                        color: Color(0xE0FFFFFF),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.settings,
                            size: 30,
                            color: Colors.black,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'SETTINGS',
                            style: TextStyle(color: Colors.black, fontSize: 12.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 156,
            child: GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? userName = prefs.getString('userName');
                if (userName != null && userName.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String kioskName = '';
                      return AlertDialog(
                        title: Text("ADD NEW KIOSK"),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                decoration: InputDecoration(labelText: "Kiosk Name"),
                                onChanged: (value) {
                                  kioskName = value.trim();
                                },
                              ),
                              SizedBox(height: 10),
                              TextButton(
                                onPressed: () async {
                                  if (kioskName.isNotEmpty) {
                                    await addKiosk(kioskName, userName);
                                    await addDenomination(kioskName,userName);
                                    Navigator.pop(context);
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Error"),
                                          content: Text("Please enter a valid kiosk name."),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Text("Add Kiosk"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text("User key not found or empty."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 70,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                      border: Border.all(
                        color: Colors.white,
                        width: 5,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 50,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


//METHODS
  void initState() {
    super.initState();
    _updateTrackerBoxes();
  }

  void _updateTrackerBoxes() async {
    String? userKey = await getUserKeyByUsername(widget.userName!);
    if (userKey != null) {
      List<String> kioskNames = await getKioskNamesFromUser(userKey);
      setState(() {
        _trackerBoxes = kioskNames;
      });
    }
  }

  Future<List<String>> getKioskNamesFromUser(String userKey) async {
    List<String> kioskNames = [];
    DatabaseReference kiosksRef = FirebaseDatabase.instance
        .ref()
        .child('owners_collection')
        .child(userName)
        .child('kiosks')
        .child('hehe')
        .child('denominations');

    try {
      DataSnapshot snapshot = (await kiosksRef.once()) as DataSnapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        Map<dynamic, dynamic> kioskMap = snapshot.value as Map<dynamic, dynamic>;
        kioskMap.forEach((key, value) {
          if (value is Map && value.containsKey('kioskName')) {
            kioskNames.add(value['kioskName']);
          }
        });
      }
    } catch (e) {
      print('Error fetching kiosk names: $e');
      // Handle the error as needed
    }

    return kioskNames;
  }

  Future<String?> getUserKeyByUsername(String userName) async {
    DatabaseReference ownersRef = FirebaseDatabase.instance.ref().child('owners_collection');
    DataSnapshot dataSnapshot = (await ownersRef.orderByChild('userName').equalTo(userName).once()).snapshot;
    String? userKey;

    Map<dynamic, dynamic>? values = dataSnapshot.value as Map<dynamic, dynamic>?;
    if (values != null) {
    userKey = values.keys.first.toString();
    }

    return userKey;
  }

  Future<void> addKiosk(String kioskName, String userName) async {
    DatabaseReference kioskRef = FirebaseDatabase.instance
        .ref()
        .child('owners_collection')
        .child(userName)
        .child('kiosks');
    await kioskRef.set({kioskName: ""});

    setState(() {
      _trackerBoxes.add(kioskName); // Update the list with the new kiosk name
    });
  }

  Future<void> addDenomination(String kioskName, String userName) async {
    DatabaseReference kioskRef = FirebaseDatabase.instance
        .ref()
        .child('owners_collection')
        .child(userName)
        .child('kiosks')
        .child(kioskName)
        .child('denominations');
    await kioskRef.set({
      '1000': 0,
      '100': 0,
      '20': 0,
      '5': 0,
      '1': 0
    });
  }

  Future<void> _deleteKiosk(String userName, String kioskName) async {
    if (kioskName != null) {
      DatabaseReference kiosksRef = FirebaseDatabase.instance.ref()
          .child('owners_collection')
          .child(userName)
          .child('kiosks')
          .child(kioskName);
      kiosksRef.remove();
      // Remove the kiosk name from the _trackerBoxes list
      setState(() {
        _trackerBoxes.remove(kioskName);
      });

      // Show a SnackBar indicating item deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kiosk deleted'),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kiosk not found'),
        ),
      );
    }
  }


}