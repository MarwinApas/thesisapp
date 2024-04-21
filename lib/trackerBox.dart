import 'package:flutter/material.dart';

class TrackerBox extends StatelessWidget {
  final String boxName;

  const TrackerBox({Key? key, required this.boxName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50.0), // Set border radius here
          border: Border.all(
            color: Color(0xFFD96C00), // Set outline color
            width: 2, // Set outline width
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 0), // Adjust top padding as needed
                child: Text(
                  'KIOSK',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 25.0), // Adjust top padding as needed
                    child: Text(
                      'PESO STACK:',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.20),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32.0), // Adjust top padding as needed
                    child: Text(
                      'FOREIGN BILL\nSTACK:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 70,left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "1000-PESO BILL STACK:",
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          "100-PESO BILL STACK:",
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          "20-PESO COIN STACK:",
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          "5-PESO COIN STACK:",
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          "1-PESO COIN STACK:",
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.3),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 90.0), // Adjust top padding as needed
                    child: Text(
                      '60%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
