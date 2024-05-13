import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thesis_app/WelcomePage.dart';
import 'package:thesis_app/flutter/Alerts.dart';
import 'package:thesis_app/flutter/Settings.dart';
import 'package:thesis_app/trackerBox.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:thesis_app/SQLite/database_helper.dart';


class Tracker extends StatefulWidget {



  const Tracker({Key? key}) : super(key: key);

  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  List<String> _trackerBoxes = [];
  late String userName;
  String kioskName = '';

  /*Future<void> check1000Denomination(String kioskName) async {
    DatabaseReference thouRef = FirebaseDatabase.instance
        .ref()
        .child('owners_collection')
        .child(userName)
        .child('kiosks')
        .child(kioskName)
        .child('denominations')
        .child('1000');

    thouRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        int? denominationValue = int.tryParse(event.snapshot.value.toString());
        if (denominationValue != null) {
          print('Denomination Value: $denominationValue');
          if (denominationValue < 3000) {
            getTimeStamp().then((timestamp) async {
              print('Timestamp: $timestamp');
              DatabaseReference sendThouNotif = FirebaseDatabase.instance
                  .ref()
                  .child('owners_collection')
                  .child(userName)
                  .child('notifications')
                  .child(timestamp);
              await sendThouNotif.set({
                "message": "The $kioskName is low on 1000 pesos",
                "isRead": false
              });
              print('Notification set successfully.');
            });
          } else {
            print('Denomination value is not greater than 3000.');
          }
        } else {
          print('Error parsing denomination value.');
        }
      } else {
        print('Denomination value is null.');
      }
    }).catchError((error) {
      print("Error fetching data: $error");
    });
  }*/


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>WelcomePage())
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
                MaterialPageRoute(builder: (context) => WelcomePage()),
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
                      boxName: _trackerBoxes[index],
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
                                    //await _deleteKiosk(userName,kioskName);
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
                                      await sendAddKioskNotification(userName, kioskName);
                                      _updateTrackerBoxes(userName);
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


//METHODS
  @override
  void initState() {
    super.initState();
    _fetchKioskNames();
    GetuserName().then((username) {
      setState(() {
        userName = username ?? '';
      });
    });
    //checkRemainingStocksPerDenomination(userName, kioskName);
    //getAlertKioskFlag();
    //checkRemainingStocksPerDenomination();
  }


  Future<void> _fetchKioskNames() async {
    try {
      String userName = await GetuserName();
      List<String> kioskNames = await getKioskNamesFromUser(userName);
      setState(() {
        _trackerBoxes.addAll(kioskNames);
      });
    } catch (error) {
      // Handle error
    }
  }

  Future<String> GetuserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName')!;
  }

  void _updateTrackerBoxes(userName) async {
    if (userName! != null) {
      List<String> kioskNames = await getKioskNamesFromUser(userName);
      setState(() {
        _trackerBoxes = kioskNames;
      });
    }
  }

  Future<List<String>> getKioskNamesFromUser(String userName) async {
    List<String> kioskNames = [];
    DatabaseReference kiosksRef = FirebaseDatabase.instance
        .ref()
        .child('owners_collection')
        .child(userName)
        .child('kiosks');

    try {
      DataSnapshot snapshot = await kiosksRef.get() as DataSnapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        Map<dynamic, dynamic> kioskMap = snapshot.value as Map<dynamic, dynamic>;

        kioskMap.keys.forEach((key) {
          if (key is String) {
            kioskNames.add(key);
          }
        });
      }
    } catch (e) {
      print('Error fetching kiosk names: $e');
      // Handle the error as needed
    }

    return kioskNames;
  }

  Future<void> addKiosk(String kioskName, String userName) async {
    DatabaseReference kioskRef = FirebaseDatabase.instance
        .ref()
        .child('owners_collection')
        .child(userName)
        .child('kiosks')
        .child(kioskName);
    kioskRef.push();

    setState(() {
      _trackerBoxes.add(kioskName); // Update the list with the new kiosk name
    });
  }

  Future<void> addDenomination(String kioskName, String userName) async {
    DatabaseReference denominationsRef =
    FirebaseDatabase.instance.ref().child('Denomination');

    // Get the database event
    DatabaseEvent denominationsEvent = await denominationsRef.once();

    // Check if the event snapshot is not null and is a DataSnapshot
    if (denominationsEvent.snapshot != null &&
        denominationsEvent.snapshot is DataSnapshot) {
      DataSnapshot dataSnapshot = denominationsEvent.snapshot as DataSnapshot;
      Map<dynamic, dynamic>? denominationsData =
      dataSnapshot.value as Map<dynamic, dynamic>?;

      if (denominationsData != null) {
        DatabaseReference kioskRef = FirebaseDatabase.instance
            .ref()
            .child('owners_collection')
            .child(userName)
            .child('kiosks')
            .child(kioskName)
            .child('denominations');

        await kioskRef.set({
          '1000': denominationsData['1000'],
          '100': denominationsData['100'],
          '20': denominationsData['20'],
          '5': denominationsData['5'],
          '1': denominationsData['1'],
          'isReadLow': false
        });
      } else {
        print('Denominations data not found.');
        // Handle the case where denominations data is not available
      }
    } else {
      print('Error fetching denominations data.');
      // Handle the case where fetching denominations data failed
    }
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

  Future<void> sendAddKioskNotification(String userName, String kioskName) async {
    String dateAndTime = await getTimeStamp();
    //dateAndTime = dateAndTime.replaceAll(".", "_"); // Replace periods with underscores
    DatabaseReference kioskRef = FirebaseDatabase.instance.ref()
        .child('owners_collection')
        .child(userName)
        .child('notifications')
        .child(dateAndTime);
    kioskRef.set(
        {
          'message': 'Kiosk ${kioskName} has been added.',
          'isRead': false
        }
        );
  }

  Future<String> getTimeStamp() async {
    var dateTime = DateTime.now(); // Replace 'DateTime.now()' with your DateTime value

    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

  /*Future<void> getAlertKioskFlag() async {
    String dateAndTime = await getTimeStamp();
    DatabaseReference alertButtonState = FirebaseDatabase.instance.ref('alertButton');
    alertButtonState.onValue.listen((event) {
      dynamic alertButton = event.snapshot.value ?? false; // Default to false if value is null
      if (alertButton) {
        /*DatabaseReference sendAlertButtonNotification = FirebaseDatabase.instance.ref()
            .child('owners_collection')
            .child(userName)
            .child('kiosks')
            .child(kioskName)
            .child('alertNotification')
            .child(dateAndTime);
        sendAlertButtonNotification.set({
          'message': 'the alert button on the ${kioskName} has been pressed!',
          'isRead': false
        });*/

        // Send the alert notification to 'notifications'
        DatabaseReference sendAlertNotification = FirebaseDatabase.instance.ref()
            .child('owners_collection')
            .child(userName)
            .child('notifications')
            .child(dateAndTime);
        sendAlertNotification.set({
          'message': 'the alert button $kioskName has been pressed!',
          'isRead': false
        }).then((_) {
          DatabaseReference returnTheAlertIntoFalse = FirebaseDatabase.instance.ref('alertButton');
          returnTheAlertIntoFalse.set(false)
              .then((_) => print('Alert button set to false after sending notifications'))
              .catchError((error) => print('Error setting alert button to false: $error'));
        }).catchError((error) => print("Error sending alert notification: $error"));
      }
    });
  }

  //constantly checks the remainingbalance
  Future<void> checkRemainingStocksPerDenomination() async {
    DatabaseReference stocksPerDenominationRef = FirebaseDatabase.instance.ref()
        .child('owners_collection')
        .child(userName)
        .child('kiosks')
        .child(kioskName)
        .child('denominations');

    stocksPerDenominationRef.onValue.listen((event) {
      if(event.snapshot.value != null && event.snapshot.value is Map) {
        Map<dynamic, dynamic> denominationsData = event.snapshot.value as Map<dynamic, dynamic>;

        Map<String, int> denominationsStock = {
          '1000': int.tryParse(denominationsData['1000'] ?? '0') ?? 0,
          '100': int.tryParse(denominationsData['100'] ?? '0') ?? 0,
          '20': int.tryParse(denominationsData['20'] ?? '0') ?? 0,
          '5': int.tryParse(denominationsData['5'] ?? '0') ?? 0,
          '1': int.tryParse(denominationsData['1'] ?? '0') ?? 0,
        };

        // Now you can check the stock levels and trigger notifications or take other actions
        int? parsedValue1000 = int.tryParse(denominationsStock['1000'].toString());
        if (parsedValue1000 != null && parsedValue1000 < 3000) {
          sendLowDenominationNotification(userName, kioskName, '1000', '');
        }
        int? parsedValue100 = int.tryParse(denominationsStock['100'].toString());
        if (parsedValue100 != null && parsedValue100 < 500) {
          sendLowDenominationNotification(userName, kioskName, '100', '');
        }
        int? parsedValue20 = int.tryParse(denominationsStock['20'].toString());
        if (parsedValue20 != null && parsedValue20 < 140) {
          sendLowDenominationNotification(userName, kioskName, '20', '');
        }
        int? parsedValue5 = int.tryParse(denominationsStock['5'].toString());
        if (parsedValue5 != null && parsedValue5 < 50) {
          sendLowDenominationNotification(userName, kioskName, '5', '');
        }
        int? parsedValue1 = int.tryParse(denominationsStock['1'].toString());
        if (parsedValue1 != null && parsedValue1 < 20) {
          sendLowDenominationNotification(userName, kioskName, '1', '');
        }

      }
    });
  }
  Future<void> sendLowDenominationNotification(String userName, String kioskName, String denomination, String message) async {
    String dateAndTime = await getTimeStamp();
    DatabaseReference denominationRef = FirebaseDatabase.instance.ref()
        .child('owners_collection')
        .child(userName)
        .child('notifications')
        .child(dateAndTime);
    denominationRef.set(
        {
          'message': 'Kiosk $kioskName has low on $denomination peso stocks. $message',
          'isRead': false
        }
    );
  }*/



}