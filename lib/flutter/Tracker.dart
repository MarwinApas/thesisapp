import 'package:flutter/material.dart';
import 'package:thesis_app/WelcomePage.dart';
import 'package:thesis_app/flutter/Alerts.dart';
import 'package:thesis_app/flutter/Settings.dart';
import 'package:thesis_app/trackerBox.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class Tracker extends StatefulWidget {
  final String? userName; // Add this line to declare the userName parameter
  const Tracker({Key? key, this.userName}) : super(key: key);
  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  final List _trackerBoxes = [];
  String numberOfKiosks = '0';



  @override
  void initState() {
    super.initState();
    DatabaseReference _kioskRef = FirebaseDatabase.instance.ref().child('kiosk');
    _kioskRef.onValue.listen((event) {
      setState(() {
        numberOfKiosks = event.snapshot.value.toString();
        _updatedefaultTrackerBoxes();
      });
    });
  }
  void _updatedefaultTrackerBoxes() {
    _trackerBoxes.clear();
    int kiosks = int.tryParse(numberOfKiosks) ?? 0;
    for (int i = 0; i < kiosks; i++) {
      _trackerBoxes.add('Thesis_kiosk ${i + 1}');
    }
  }
  Future<String?> getUserKeyByUsername(String? userName) async {
    DatabaseReference ownersRef = FirebaseDatabase.instance.ref().child('owners_collection');
    DataSnapshot dataSnapshot =
        (await ownersRef.orderByChild('userName').equalTo(userName).once()).snapshot;
    String? userKey;

    Map<dynamic, dynamic>? values = dataSnapshot.value as Map<dynamic, dynamic>?;
    if (values != null) {
      userKey = values.keys.first.toString();
    }

    return userKey;
  }
  void _saveKioskName(String kioskName) async {
    String? userKey = await getUserKeyByUsername(widget.userName);
    if (userKey != null) {
      DatabaseReference kioskRef = FirebaseDatabase.instance
          .ref()
          .child('owners_collection')
          .child(userKey)
          .child('kiosks');
      kioskRef.push().set({'kioskName': kioskName});
    }
  }
  void _showAddKioskDialog() {
    String kioskName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Kiosk'),
          content: TextField(
            onChanged: (value) {
              kioskName = value;
            },
            decoration: InputDecoration(hintText: 'Enter Kiosk Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Save kioskName under owners_collection/userKey
                _saveKioskName(kioskName);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Add Kiosk'),
            ),
          ],
        );
      },
    );
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
              Icons.arrow_back, // You can replace this with your custom back icon
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
            "TRACKER",
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
              height: MediaQuery.of(context).size.height *0.9, // Adjust the multiplier as needed
              child: ListView.builder(
                itemCount: _trackerBoxes.length,
                itemBuilder: (context, index) {
                  return TrackerBox(
                    boxName: _trackerBoxes[index],
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
                height: 90, // Adjust the height as needed
                color: Color(0xff02022d), // Adjust the color as needed
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
                onTap: () {
                  // Increment 'kiosk' value in Firebase
                  DatabaseReference _kioskRef = FirebaseDatabase.instance.ref().child('kiosk');
                  int currentKiosk = int.tryParse(numberOfKiosks) ?? 0;
                  _kioskRef.set(currentKiosk + 1); // Increment 'kiosk' by 1
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
}
