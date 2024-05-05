import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'dart:convert';
//import 'package:flutter/services.dart' show rootBundle;

class TrackerBox extends StatefulWidget {
  final String boxName;
  final VoidCallback onDelete;

  const TrackerBox({Key? key, required this.boxName, required this.onDelete})
      : super(key: key);

  @override
  _TrackerBoxState createState() => _TrackerBoxState();
}

class _TrackerBoxState extends State<TrackerBox> {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _expanded = false;
  late String userName; // Define userKey variable
  double usdRate = 0.0;
  double audRate = 0.0;
  double krwRate = 0.0;
  double feeRate = 0.0;


  @override
  void initState() {
    super.initState();
    fetchCurrencyRates();
    GetUserName().then((username) {
      setState(() {
        userName = username ?? '';
      });
    });
    getAlertKioskFlag();
    //checkRemainingStocksPerDenomination();
    //fetchData();
    //readSecretKey();
    //check1000Denomination();
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
//READ USD CURRENCY RATE METHOD
  Future<double> fetchUSDRate() async {
    DatabaseReference usdRateRef = FirebaseDatabase.instance
        .ref()
        .child('currency_rate')
        .child('USD_rate');

    Completer<double> completer = Completer<double>();

    usdRateRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        double rate = double.parse(event.snapshot.value.toString());
        setState(() {
          usdRate = rate;
        });
        completer.complete(rate); // Resolve the Future with the fetched rate
      } else {
        print("USD rate snapshot does not exist");
        completer.completeError("USD rate snapshot does not exist"); // Resolve with an error if snapshot does not exist
      }
    }, onError: (error) {
      print("Error fetching USD rate: $error");
      completer.completeError(error); // Resolve with an error if there's an error fetching the rate
    });

    return completer.future;
  }
// READ AUD CURRENCY RATE METHOD
  Future<double> AUDRateToday() async {
    DatabaseReference usdRateRef = FirebaseDatabase.instance
        .ref()
        .child('currency_rate')
        .child('AUD_rate');

    Completer<double> completer = Completer<double>();

    usdRateRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        double rate = double.parse(event.snapshot.value.toString());
        setState(() {
          audRate = rate;
        });
        completer.complete(rate); // Resolve the Future with the fetched rate
      } else {
        print("USD rate snapshot does not exist");
        completer.completeError("USD rate snapshot does not exist"); // Resolve with an error if snapshot does not exist
      }
    }, onError: (error) {
      print("Error fetching USD rate: $error");
      completer.completeError(error); // Resolve with an error if there's an error fetching the rate
    });

    return completer.future;
  }
// READ KRW CURRENCY RATE METHOD
  Future<double> KRWRateToday() async {
    DatabaseReference usdRateRef = FirebaseDatabase.instance
        .ref()
        .child('currency_rate')
        .child('KRW_rate');

    Completer<double> completer = Completer<double>();

    usdRateRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        double rate = double.parse(event.snapshot.value.toString());
        setState(() {
          krwRate = rate;
        });
        completer.complete(rate); // Resolve the Future with the fetched rate
      } else {
        print("USD rate snapshot does not exist");
        completer.completeError("USD rate snapshot does not exist"); // Resolve with an error if snapshot does not exist
      }
    }, onError: (error) {
      print("Error fetching USD rate: $error");
      completer.completeError(error); // Resolve with an error if there's an error fetching the rate
    });

    return completer.future;
  }
  // READ FEE RATE METHOD
  Future<double> FEERateToday() async {
    DatabaseReference usdRateRef = FirebaseDatabase.instance
        .ref()
        .child('currency_rate')
        .child('FEE_rate');

    Completer<double> completer = Completer<double>();

    usdRateRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        double rate = double.parse(event.snapshot.value.toString());
        setState(() {
          feeRate = rate;
        });
        completer.complete(rate); // Resolve the Future with the fetched rate
      } else {
        print("USD rate snapshot does not exist");
        completer.completeError("USD rate snapshot does not exist"); // Resolve with an error if snapshot does not exist
      }
    }, onError: (error) {
      print("Error fetching USD rate: $error");
      completer.completeError(error); // Resolve with an error if there's an error fetching the rate
    });

    return completer.future;
  }
  Future<void> fetchCurrencyRates() async {
    await fetchUSDRate();
    await AUDRateToday();
    await KRWRateToday();
    await FEERateToday();
  }
  Future<String> getTimeStamp() async {
    var dateTime = DateTime.now(); // Replace 'DateTime.now()' with your DateTime value

    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }
  Future<void> getAlertKioskFlag() async {
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
          'message': 'the alert button in ${widget.boxName} has been pressed!',
          'isRead': false
        });/*.then((_) {
          DatabaseReference returnTheAlertIntoFalse = FirebaseDatabase.instance.ref('alertButton');
          returnTheAlertIntoFalse.set(false)
              .then((_) => print('Alert button set to false after sending notifications'))
              .catchError((error) => print('Error setting alert button to false: $error'));
        }).catchError((error) => print("Error sending alert notification: $error"));*/
      }
    });
  }

  /*Future<void> check1000Denomination() async {
    DatabaseReference thouRef = FirebaseDatabase.instance
        .ref()
        .child('owners_collection')
        .child(userName)
        .child('kiosks')
        .child(widget.boxName)
        .child('denominations')
        .child('1000');

    thouRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        int? denominationValue = int.tryParse(event.snapshot.value.toString());
        if (denominationValue != null) {
          print('Denomination Value: $denominationValue');
          if (denominationValue < 3000) {
            getTimeStamp().then((timestamp) async {
              DatabaseReference sendThouNotif = FirebaseDatabase.instance
                  .ref()
                  .child('owners_collection')
                  .child(userName)
                  .child('notifications')
                  .child(timestamp);
              await sendThouNotif.set({
                "message": "The ${widget.boxName} is low on 1000 pesos",
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
  }


  Future<void> checkRemainingStocksPerDenomination() async {
    DatabaseReference stocksPerDenominationRef = FirebaseDatabase.instance.ref()
        .child('owners_collection')
        .child(userName)
        .child('kiosks')
        .child(widget.boxName)
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
          sendLowDenominationNotification(userName, widget.boxName, '1000', '');
        }
        int? parsedValue100 = int.tryParse(denominationsStock['100'].toString());
        if (parsedValue100 != null && parsedValue100 < 500) {
          sendLowDenominationNotification(userName, widget.boxName, '100', '');
        }
        int? parsedValue20 = int.tryParse(denominationsStock['20'].toString());
        if (parsedValue20 != null && parsedValue20 < 140) {
          sendLowDenominationNotification(userName, widget.boxName, '20', '');
        }
        int? parsedValue5 = int.tryParse(denominationsStock['5'].toString());
        if (parsedValue5 != null && parsedValue5 < 50) {
          sendLowDenominationNotification(userName, widget.boxName, '5', '');
        }
        int? parsedValue1 = int.tryParse(denominationsStock['1'].toString());
        if (parsedValue1 != null && parsedValue1 < 20) {
          sendLowDenominationNotification(userName, widget.boxName, '1', '');
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
          'message': 'Kiosk ${widget.boxName} has low on $denomination peso stocks. $message',
          'isRead': false
        }
    );
  }*/


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
        height: _expanded ? 450 : 80, // Set expanded and default heights
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
                                  .child('owners_collection')
                                  .child(userName)
                                  .child('kiosks')
                                  .child(widget.boxName)
                                  .child('denominations')
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
                                  if ((int.tryParse(denominationsData['1000']) ?? 0) < 3000) {
                                    getTimeStamp().then((timestamp) async {
                                      DatabaseReference sendThouNotif = FirebaseDatabase.instance
                                          .ref()
                                          .child('owners_collection')
                                          .child(userName)
                                          .child('notifications')
                                          .child(timestamp);
                                      await sendThouNotif.set({
                                        "message": "The ${widget.boxName} is low on 1000 pesos",
                                        "isRead": false
                                      });
                                      print('Notification set successfully.');
                                    });
                                  }
                                  else if ((int.tryParse(denominationsData['100']) ?? 0) < 500) {
                                    getTimeStamp().then((timestamp) async {
                                      DatabaseReference sendThouNotif = FirebaseDatabase.instance
                                          .ref()
                                          .child('owners_collection')
                                          .child(userName)
                                          .child('notifications')
                                          .child(timestamp);
                                      await sendThouNotif.set({
                                        "message": "The ${widget.boxName} is low on 1000 pesos",
                                        "isRead": false
                                      });
                                      print('Notification set successfully.');
                                    });
                                  }
                                  else if ((int.tryParse(denominationsData['20']) ?? 0) < 100) {
                                    getTimeStamp().then((timestamp) async {
                                      DatabaseReference sendThouNotif = FirebaseDatabase.instance
                                          .ref()
                                          .child('owners_collection')
                                          .child(userName)
                                          .child('notifications')
                                          .child(timestamp);
                                      await sendThouNotif.set({
                                        "message": "The ${widget.boxName} is low on 100 pesos",
                                        "isRead": false
                                      });
                                      print('Notification set successfully.');
                                    });
                                  }
                                  else if ((int.tryParse(denominationsData['5']) ?? 0) < 50) {
                                    getTimeStamp().then((timestamp) async {
                                      DatabaseReference sendThouNotif = FirebaseDatabase.instance
                                          .ref()
                                          .child('owners_collection')
                                          .child(userName)
                                          .child('notifications')
                                          .child(timestamp);
                                      await sendThouNotif.set({
                                        "message": "The ${widget.boxName} is low on 5 pesos",
                                        "isRead": false
                                      });
                                      print('Notification set successfully.');
                                    });
                                  }
                                  else if ((int.tryParse(denominationsData['1']) ?? 0) < 10) {
                                    getTimeStamp().then((timestamp) async {
                                      DatabaseReference sendThouNotif = FirebaseDatabase.instance
                                          .ref()
                                          .child('owners_collection')
                                          .child(userName)
                                          .child('notifications')
                                          .child(timestamp);
                                      await sendThouNotif.set({
                                        "message": "The ${widget.boxName} is low on 1 pesos",
                                        "isRead": false
                                      });
                                      print('Notification set successfully.');
                                    });
                                  }
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
                            SizedBox(height: 50),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Transaction History"),
                                      content: Text("Here is your transaction history."),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the alert dialog
                                          },
                                          child: Text("Close"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text("TAP TO SEE THE TRANSACTION HISTORY"),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String selectedCurrency = 'USD_rate'; // Default selected currency
                                    TextEditingController priceController = TextEditingController(); // Controller for the price input field

                                    return AlertDialog(
                                      title: Text("Set Price"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min, // Set the dialog content size to minimum
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "DAILY RATE:",
                                            style: TextStyle(
                                              fontSize: 14, // Set the font size
                                              fontWeight: FontWeight.bold, // Set the font weight to bold
                                              color: Colors.black, // Set the text color
                                            ),
                                          ),
                                          FutureBuilder<double>(
                                            future: fetchUSDRate(), // Call your fetch methods here
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text("Error: ${snapshot.error}");
                                              } else if (!snapshot.hasData) {
                                                return Text("No data available");
                                              } else {
                                                // Use snapshot.data to access the fetched rate
                                                double usdRate = snapshot.data!;
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "USD: ${usdRate.toStringAsFixed(2)} PESOS",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    FutureBuilder<double>(
                                                      future: AUDRateToday(), // Call your fetch methods here
                                                      builder: (context, snapshot) {
                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                          return CircularProgressIndicator();
                                                        } else if (snapshot.hasError) {
                                                          return Text("Error: ${snapshot.error}");
                                                        } else if (!snapshot.hasData) {
                                                          return Text("No data available");
                                                        } else {
                                                          // Use snapshot.data to access the fetched rate
                                                          double audRate = snapshot.data!;
                                                          return Text(
                                                            "AUD: ${audRate.toStringAsFixed(2)} PESOS",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                    FutureBuilder<double>(
                                                      future: KRWRateToday(), // Call your fetch methods here
                                                      builder: (context, snapshot) {
                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                          return CircularProgressIndicator();
                                                        } else if (snapshot.hasError) {
                                                          return Text("Error: ${snapshot.error}");
                                                        } else if (!snapshot.hasData) {
                                                          return Text("No data available");
                                                        } else {
                                                          // Use snapshot.data to access the fetched rate
                                                          double krwRate = snapshot.data!;
                                                          return Text(
                                                            "KRW: ${krwRate.toStringAsFixed(3)} PESOS",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                    FutureBuilder<double>(
                                                      future: FEERateToday(), // Call your fetch methods here
                                                      builder: (context, snapshot) {
                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                          return CircularProgressIndicator();
                                                        } else if (snapshot.hasError) {
                                                          return Text("Error: ${snapshot.error}");
                                                        } else if (!snapshot.hasData) {
                                                          return Text("No data available");
                                                        } else {
                                                          // Use snapshot.data to access the fetched rate
                                                          double krwRate = snapshot.data!;
                                                          return Text(
                                                            "FEE: ${krwRate.toStringAsFixed(3)} PESOS",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                          DropdownButtonFormField<String>(
                                            value: selectedCurrency,
                                            items: ['USD_rate', 'AUD_rate', 'KRW_rate','FEE_rate'].map((String currency) {
                                              return DropdownMenuItem<String>(
                                                value: currency,
                                                child: Text(currency),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              if (newValue != null) {
                                                setState(() {
                                                  selectedCurrency = newValue;
                                                });
                                              }
                                            },
                                          ),
                                          SizedBox(height: 10), // Add space between dropdown and text field
                                          TextField(
                                            controller: priceController,
                                            keyboardType: TextInputType.number, // Set keyboard type to number
                                            decoration: InputDecoration(
                                              labelText: "Enter Price",
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context); // Close the dialog
                                          },
                                          child: Text("Cancel"), // Text for the cancel button
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            // Get the selected currency and price here
                                            String currency = selectedCurrency;
                                            String price = priceController.text ?? '0.0';

                                            DatabaseReference currencyPriceRef = FirebaseDatabase.instance
                                                .ref()
                                                .child('currency_rate')
                                                .child(currency);

                                            currencyPriceRef.set(price).then((_) {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text('Price for $currency set successfully!'),
                                              ));
                                            }).catchError((error) {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text('Error setting price: $error'),
                                              ));
                                            });
                                          },
                                          child: Text("Set Price"), // Text for the set price button
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text("Set Price"), // Label the button as "Set Price"
                            ),


                          ],
                        ),
                      ),
                    ),

                  SizedBox(height: 10),

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