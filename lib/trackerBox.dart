import 'dart:async';

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
    fetchCurrencyRates();
    GetUserName().then((username) {
      setState(() {
        userName = username ?? '';
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

  double usdRate = 0.0;
  double audRate = 0.0;
  double krwRate = 0.0;

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
  Future<void> fetchCurrencyRates() async {
    await fetchUSDRate();
    await AUDRateToday();
    await KRWRateToday();
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
        height: _expanded ? 580 : 80, // Set expanded and default heights
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
                            SizedBox(height: 14),
                            Text(
                              "TRANSACTION HISTORY",
                              style: TextStyle(
                                fontSize: 18, // Set the font size
                                fontWeight: FontWeight.bold, // Set the font weight to bold
                                color: Colors.black, // Set the text color
                              ),
                            ),
                            SizedBox(height: 7),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20), // Set border radius to 20 pixels
                                border: Border.all(width: 2), // Set border width to 2 pixels
                              ),
                              padding: EdgeInsets.all(2.0), // Add padding around the ListView
                              height: 230, // Set a specific height for the Container
                              width: 290,
                              child: ListView.builder(
                                itemCount: 7, // Example item count, replace with your actual data count
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    title: Text('A new transaction on kiosk $index'), // Example text for each list item
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String selectedCurrency = 'USD'; // Default selected currency
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
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                          DropdownButtonFormField<String>(
                                            value: selectedCurrency,
                                            items: ['USD', 'AUD', 'KRW'].map((String currency) {
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
                                            double price = double.tryParse(priceController.text) ?? 0.0;

                                            DatabaseReference currencyPriceRef = FirebaseDatabase.instance
                                                .ref()
                                                .child('currency_price')
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