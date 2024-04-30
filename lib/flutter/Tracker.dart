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
  String numberOfKiosks = '0';

  @override
  void initState() {
    super.initState();
    DatabaseReference _kioskRef = FirebaseDatabase.instance.reference().child('kiosk');
    _kioskRef.onValue.listen((event) {
      setState(() {
        numberOfKiosks = event.snapshot.value.toString();
        if (_trackerBoxes.isEmpty) {
          _updateTrackerBoxes(); // Update the list only if it's empty
        }
      });
    });
  }

  void _updateTrackerBoxes() {
    _trackerBoxes.clear();
    int kiosks = int.tryParse(numberOfKiosks) ?? 0;
    for (int i = 0; i < kiosks; i++) {
      _trackerBoxes.add('kiosk ${i + 1}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage(userName: widget.userName)),
        );
        return false;
      },
      child: Scaffold(
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
                  onDelete: () {
                    setState(() {
                      _trackerBoxes.removeAt(index);
                    });
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
                          MaterialPageRoute(builder: (context) => WelcomePage()),
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
                  String? userKey = await getUserKeyByUsername(userName!);
                  if (userKey != null && userKey.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String kioskName = '';
                        int denomination1000 = 0;
                        int denomination100 = 0;
                        int denomination20 = 0;
                        int denomination5 = 0;
                        int denomination1 = 0;

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
                                      await addKiosk(kioskName, userKey);
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
      ),
    );
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

  Future<void> addKiosk(String kioskName, String userKey) async {
    DatabaseReference kioskRef = FirebaseDatabase.instance
        .ref()
        .child('owners_collection')
        .child(userKey)
        .push();
    await kioskRef.set({
      'kioskName': kioskName,
    });

    setState(() {
      _trackerBoxes.add(kioskName); // Update the list with the new kiosk name
    });
  }

  Future<void> addNewKioskInfo(String userKey, String kioskKey) async {
    DatabaseReference kioskRef = FirebaseDatabase.instance
        .ref()
        .child('owners_collection')
        .child(userKey)
        .child(kioskKey)
        .push();

  }
}
