
import 'package:thesis_app/WelcomePage.dart';
import 'package:thesis_app/flutter/Settings.dart';
import 'package:thesis_app/flutter/Tracker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Alerts extends StatefulWidget {
  const Alerts({Key? key});

  @override
  State<Alerts> createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  DatabaseReference _kioskRef = FirebaseDatabase.instance.reference().child('kiosk'); // Firebase reference for 'kiosk'
  @override
  void initState() {
    super.initState();
    _checkNewKiosk(); // Call the method to check for new kiosks when the Alerts tab is initialized
  }

  void _checkNewKiosk() async {
    DataSnapshot snapshot = (await _kioskRef.once()) as DataSnapshot; // Get a snapshot of the 'kiosk' value
    int currentKiosk = snapshot.value as int; // Assuming 'kiosk' is an integer value in Firebase

    // Check if the current kiosk value is greater than the previous value stored in local storage
    // You can use shared_preferences or another local storage solution for this
    int previousKiosk = await _getPreviousKioskValue(); // Implement this method to get the previous kiosk value
    if (currentKiosk > previousKiosk) {
      // If a new kiosk has been added, show the notification
      _showNewKioskNotification(currentKiosk);
    }
  }

  Future<int> _getPreviousKioskValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? previousKiosk = prefs.getInt('previousKiosk'); // Get the previous kiosk value from SharedPreferences
    return previousKiosk ?? 0; // Return 0 if no previous value is found
  }

  void _showNewKioskNotification(int currentKiosk) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("New Kiosk Added"),
          content: Text("A new kiosk has been added. Current kiosk count: $currentKiosk"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
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
              MaterialPageRoute(builder: (context)=>WelcomePage()),
            );
          },
        ),
        title: Text(
          "ALERTS",
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "UNREAD NOTIFICATIONS",
                  style: TextStyle(
                    color: Color(0xFFA94F02),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                height: 2,
                color: Colors.grey,
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 8), // Add some space between icon and text
                    Text(
                      "A new device has been added",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 2,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "NOTIFICATIONS",
                  style: TextStyle(
                    color: Color(0xFFA94F02),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                height: 2,
                color: Colors.grey,
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Notification will pop up here",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 90,  // Adjust the height as needed
              color: Color(0xff02022d),  // Adjust the color as needed

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomePage(),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => Tracker(),
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
                            Icons.radar_sharp,
                            size: 30,
                            color: Colors.black,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'TRACKER',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.5,
                            ),
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
                          Icons.notification_important,
                          size: 30,
                          color: Colors.white,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'ALERTS',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => Settings(),
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
                            style: TextStyle(color: Colors.black,
                                fontSize: 12.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
