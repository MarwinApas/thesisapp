import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  Map<String, int> transactionHistory = {};
  List<String> transactionNumberHistory = [];
  double totalSalesToday = 0.0;
  double totalSalesThisWeek = 0.0;
  double totalSalesThisMonth = 0.0;
  String transactionCheck = '';


  @override
  void initState() {
    super.initState();
    fetchCurrencyRates();
    GetUserName().then((username) {
      setState(() {
        userName = username ?? '';
        updateTransactionHistory();
      });
    });
    getAlertKioskFlag();
    //checkRemainingStocksPerDenomination();
    //fetchData();
    //readSecretKey();
    //check1000Denomination();
  }

  Future<void> setStringKioskName (String kioskName) async{
    SharedPreferences prefsKioskName = await SharedPreferences.getInstance();
    prefsKioskName.setString('kioskName', widget.boxName);
  }

  void updateTransactionHistory() async {
    await FetchTransactionHistory();
  }

  //daily transaction history
  Future<void> FetchTransactionHistory() async{
    DateTime now = DateTime.now();
    String monthName = DateFormat('MMMM').format(now);
    String day = DateFormat('d').format(now);
    List<String> historyToday = [];
    DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('owners_collection')
        .child(userName.toString())
        .child('kiosks')
        .child(widget.boxName)
        .child('transaction_history')
        .child(monthName)
        .child(day);
    try {
      DataSnapshot snapshot = await historyRef.get() as DataSnapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        Map<dynamic, dynamic> kioskMap = snapshot.value as Map<dynamic, dynamic>;
        kioskMap.entries.forEach((entry) {
          String key = entry.key;
          int value = entry.value;

          transactionNumberHistory.add(key);
          transactionHistory[key] = value;
          totalSalesToday = totalSalesToday + value;
        });
      }
    } catch (e) {
      transactionCheck = '$e';
      print('Error fetching kiosk transaction history: $e');
    }
  }

  //weekly transaction history
  Future<void> FetchWeeklyTransactionHistory() async {
    DateTime now = DateTime.now();
    String monthName = DateFormat('MMMM').format(now);
    List<String> historyThisWeek = [];

    DateTime startDate = now.subtract(Duration(days: now.weekday - 1));
    DateTime endDate = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));

    DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('owners_collection')
        .child(userName.toString())
        .child('kiosks')
        .child(widget.boxName)
        .child('transaction_history')
        .child(monthName);

    try {
      DataSnapshot snapshot = await historyRef.get() as DataSnapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        Map<dynamic, dynamic> kioskMap = snapshot.value as Map<dynamic, dynamic>;
        kioskMap.forEach((day, dayData) {
          DateTime dayDateTime = DateTime.parse(day);
          if (dayDateTime.isAfter(startDate.subtract(Duration(days: 1))) && dayDateTime.isBefore(endDate.add(Duration(days: 1)))) {
            dayData.forEach((key, value) {
              historyThisWeek.add('$day $key: $value');
              totalSalesThisWeek += value;
            });
          }
        });
      }
    } catch (e) {
      transactionCheck = '$e';
      print('Error fetching kiosk weekly transaction history: $e');
    }

    setState(() {
      totalSalesThisWeek = totalSalesThisWeek;
    });
  }

  //monthly transaction history
  Future<void> FetchMonthlyTransactionHistory() async {
    DateTime now = DateTime.now();
    String monthName = DateFormat('MMMM').format(now);
    List<String> historyThisMonth = [];

    DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('owners_collection')
        .child(userName.toString())
        .child('kiosks')
        .child(widget.boxName)
        .child('transaction_history')
        .child(monthName);

    try {
      DataSnapshot snapshot = await historyRef.get() as DataSnapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        Map<dynamic, dynamic> kioskMap = snapshot.value as Map<dynamic, dynamic>;
        kioskMap.forEach((day, dayData) {
          dayData.forEach((key, value) {
            historyThisMonth.add('$day $key: $value');
            totalSalesThisMonth += value;
          });
        });
      }
    } catch (e) {
      transactionCheck = '$e';
      print('Error fetching kiosk monthly transaction history: $e');
    }

    setState(() {
      totalSalesThisMonth = totalSalesThisMonth;
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
        completer.complete(rate);
      } else {
        print("USD rate snapshot does not exist");
        completer.completeError("USD rate snapshot does not exist");
      }
    }, onError: (error) {
      print("Error fetching USD rate: $error");
      completer.completeError(error);
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
        completer.complete(rate);
      } else {
        print("USD rate snapshot does not exist");
        completer.completeError("USD rate snapshot does not exist");
      }
    }, onError: (error) {
      print("Error fetching USD rate: $error");
      completer.completeError(error);
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
        completer.complete(rate);
      } else {
        print("USD rate snapshot does not exist");
        completer.completeError("USD rate snapshot does not exist");
      }
    }, onError: (error) {
      print("Error fetching USD rate: $error");
      completer.completeError(error);
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
        completer.complete(rate);
      } else {
        print("USD rate snapshot does not exist");
        completer.completeError("USD rate snapshot does not exist");
      }
    }, onError: (error) {
      print("Error fetching USD rate: $error");
      completer.completeError(error);
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
    DatabaseReference alertButtonState = FirebaseDatabase.instance.ref()
    .child('owners_collection')
    .child(userName)
    .child('kiosks')
    .child(widget.boxName)
    .child('alertButton')
    .child('isPressed');
    alertButtonState.onValue.listen((event) {
      dynamic alertButton = event.snapshot.value ?? false; // Default to false if value is null
      if (alertButton) {
        // Send the alert notification to 'notifications'
        DatabaseReference sendAlertNotification = FirebaseDatabase.instance.ref()
            .child('owners_collection')
            .child(userName)
            .child('notifications')
            .child(dateAndTime);
        sendAlertNotification.set({
          'message': 'the alert button in ${widget.boxName} has been pressed!',
          'isRead': false
        }).then((_){
          setStringKioskName(widget.boxName);
        });
      }
    });
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
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Center(
                                        child: Column(
                                          children: [
                                            Text("Transaction History"),
                                            Text("${DateFormat('MMMM d, yyyy').format(DateTime.now())}")
                                          ],
                                        )
                                        /*Text(
                                          "Transaction History ${DateFormat('MMMM d, yyyy').format(DateTime.now())}",
                                        ),*/
                                      ),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              height: transactionHistory.length * 70.0,
                                              width: double.maxFinite,
                                              child: ListView.builder(
                                                itemCount: transactionHistory.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return ListTile(
                                                    title: Text(
                                                      "${transactionNumberHistory[index]}: Kiosk ${widget.boxName} received ${transactionHistory[transactionNumberHistory[index]].toString()} pesos",
                                                      style: TextStyle(fontSize: 12),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),

                                            SizedBox(height: 10),
                                            Text("Total sales today: $totalSalesToday pesos"),
                                            Text("Total sales this week: $totalSalesThisWeek pesos"),
                                            Text("Total sales this month: $totalSalesThisMonth pesos"),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
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

                                            //if fee rate is selected
                                            if(selectedCurrency =='FEE_rate'){
                                              double feeRate = double.parse(price);
                                              double usdRate = await fetchUSDRate();
                                              double audRate = await AUDRateToday();
                                              double krwRate = await KRWRateToday();

                                              double updatedAudPrice = audRate - (audRate * feeRate);
                                              double updatedUsdPrice = usdRate - (usdRate * feeRate);
                                              double updatedKrwPrice = krwRate - (krwRate * feeRate);

                                              DatabaseReference audPriceRef = FirebaseDatabase.instance
                                                  .ref()
                                                  .child('currency_rate')
                                                  .child('AUD_rate');
                                              DatabaseReference usdPriceRef = FirebaseDatabase.instance
                                                  .ref()
                                                  .child('currency_rate')
                                                  .child('USD_rate');
                                              DatabaseReference krwPriceRef = FirebaseDatabase.instance
                                                  .ref()
                                                  .child('currency_rate')
                                                  .child('KRW_rate');

                                              // Update AUD rate
                                              audPriceRef.set(updatedAudPrice.toStringAsFixed(2)).then((_) {
                                                // Update USD rate
                                                usdPriceRef.set(updatedUsdPrice.toStringAsFixed(2)).then((_) {
                                                  // Update KRW rate
                                                  krwPriceRef.set(updatedKrwPrice.toStringAsFixed(4)).then((_) {
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                      content: Text('Prices updated successfully!'),
                                                    ));
                                                  }).catchError((error) {
                                                   // handleSetPriceError(context, error);
                                                  });
                                                }).catchError((error) {
                                                 // handleSetPriceError(context, error);
                                                });
                                              }).catchError((error) {
                                               // handleSetPriceError(context, error);
                                              });
                                            }

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
                                          child: Text("Set Price"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text("Set Price"),
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