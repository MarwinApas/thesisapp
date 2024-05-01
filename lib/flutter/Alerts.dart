

import 'package:thesis_app/WelcomePage.dart';
import 'package:thesis_app/flutter/Settings.dart';
import 'package:thesis_app/flutter/Tracker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Alerts extends StatefulWidget {
  final String? userName;
  const Alerts({Key? key, this.userName});

  @override
  State<Alerts> createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  @override
  void initState() {
    super.initState();
    fetchUserKiosks();
  }


//gets the current logged-in username
  Future<String> GetUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName')!;
  }

  List<String?> notifications = [];
  Future<void> fetchUserKiosks() async {
    String userName = await GetUserName();


    if (userName != null) {
      try {
        List<String?> fetchedKioskNames = await getUnReadNotificationsFromUser(userName);
        notifications.clear();
        notifications.addAll(fetchedKioskNames);

        setState(() {});
      } catch (e) {
        print('Error fetching kiosk names: $e');
      }
    } else {
      print('UserName is null');
    }
  }

  Future<List<String?>> getReadNotificationsFromUser(String userName) async {
    List<String?> notifications = [];
    DatabaseReference kiosksRef = FirebaseDatabase.instance
        .ref()
        .child('owners_collection')
        .child(userName)
        .child('notifications');

    try {
      DataSnapshot snapshot = await kiosksRef.get() as DataSnapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        Map<dynamic, dynamic> kioskMap = snapshot.value as Map<dynamic, dynamic>;

        kioskMap.values.forEach((value) {
          if (value is Map<dynamic, dynamic>) {
            // Access the properties of each item in the snapshot
            dynamic isRead = value['isRead'];
            // Check if the 'isRead' property is true or false
            if (isRead == true) {
              notifications.add(value['message']);
            }
          }
        });
      }
    } catch (e) {
      print('Error fetching kiosk names: $e');
    }

    return notifications;
  }

  Future<List<String?>> getUnReadNotificationsFromUser(String userName) async {
    List<String?> notifications = [];
    DatabaseReference kiosksRef = FirebaseDatabase.instance
        .ref()
        .child('owners_collection')
        .child(userName)
        .child('notifications');

    try {
      DataSnapshot snapshot = await kiosksRef.get() as DataSnapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        Map<dynamic, dynamic> kioskMap = snapshot.value as Map<dynamic, dynamic>;

        kioskMap.values.forEach((value) {
          if (value is Map<dynamic, dynamic>) {
            // Access the properties of each item in the snapshot
            dynamic isRead = value['isRead'];
            // Check if the 'isRead' property is true or false
            if (isRead == false) {
              notifications.add(value['message']);
            }
          }
        });
      }
    } catch (e) {
      print('Error fetching kiosk names: $e');
    }

    return notifications;
  }

  Future<List<String?>> updateNotificationsFromUser(String userName) async {
    List<String?> notifications = [];
    DatabaseReference kiosksRef = FirebaseDatabase.instance
        .ref()
        .child('owners_collection')
        .child(userName)
        .child('notifications');

    try {
      DataSnapshot snapshot = await kiosksRef.get() as DataSnapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        Map<dynamic, dynamic> kioskMap = snapshot.value as Map<dynamic, dynamic>;

        kioskMap.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            // Access the properties of each item in the snapshot
            dynamic isRead = value['isRead'];
            // Check if the 'isRead' property is false
            if (isRead == false) {
              notifications.add(value['message']);
              // Update the 'isRead' property to true
              kiosksRef.child(key).update({'isRead': true});
            }
          }
        });
      }
    } catch (e) {
      print('Error fetching kiosk names: $e');
    }

    return notifications;
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "UNREAD NOTIFICATIONS",
                        style: TextStyle(
                          color: Color(0xFFA94F02),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{

                          setState(() {
                            //updateNotificationsFromUser(userName);
                            //notifications.clear();
                          });
                          // For example, you can show a confirmation dialog here
                        },
                        child: Icon(
                          Icons.arrow_downward,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 2,
                  color: Colors.grey,
                ),
                SizedBox(height: 8),
                Container(
                  height: 150, // Set a height for the container
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 8), // Add some space between icon and text
                            Text(
                              "${notifications[index]}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
                Container(
                  height: 150, // Set a height for the container
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(width: 8), // Add some space between icon and text
                            Text(
                              "${notifications[index]}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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



//METHOD to RETRIEVE DATA


