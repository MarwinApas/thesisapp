import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thesis_app/LoginPage.dart';
import 'package:thesis_app/flutter/Alerts.dart';
import 'package:thesis_app/flutter/Settings.dart';
import 'package:thesis_app/flutter/Tracker.dart';

class WelcomePage extends StatelessWidget {
  final String? userName; // Add this line to declare the userName parameter
  const WelcomePage({Key? key, this.userName}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("login page", style: TextStyle(fontWeight: FontWeight.bold),),
              content: Text("Are you sure you want to go back to the login page?", style: TextStyle(fontSize: 16),),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    // Perform logout logic here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: Text("Confirm"),
                ),
              ],
            );
          },
        );
        return false; // Prevents the default back navigation behavior
      },
    child: Scaffold(
      backgroundColor: Color(0xE0FFFFFF),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff02022d),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, // You can replace this with your custom back icon
            color: Colors.white,
          ),
          onPressed: ()  {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("login page", style: TextStyle(fontWeight: FontWeight.bold),),
                  content: Text("Are you sure you want to go back to the login page?", style: TextStyle(fontSize: 16),),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: Text("Confirm"),
                    ),
                  ],
                );
              },
            );
          },
        ),
        title: Text(
          "HOME",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Align(
                  child: Container(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 90.0),
                        child: Text(
                          "WELCOME!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // TRACKER AND ALERTS
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Tracker(),
                                ),
                              );
                            },
                            child: Align(
                              alignment: Alignment(-0.64, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFD96C00),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 140,
                                height: 140,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.track_changes,
                                      size: 80,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'TRACKER',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Alerts(),
                                ),
                              );
                            },
                            child: Align(
                              alignment: Alignment(0.64, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFD96C00),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 140,
                                height: 140,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.notifications,
                                      size: 80,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'ALERTS',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // SETTINGS AND LOGOUT
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Settings(),
                                ),
                              );
                            },
                            child: Align(
                              alignment: Alignment(-0.64, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFD96C00),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 140,
                                height: 140,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.settings,
                                      size: 80,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'SETTINGS',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Logout", style: TextStyle(fontWeight: FontWeight.bold),),
                                    content: Text("Are you sure you want to logout?", style: TextStyle(fontSize: 16),),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          FirebaseAuth.instance.signOut();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginPage(),
                                            ),
                                          );
                                        },
                                        child: Text("Confirm"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Align(
                              alignment: Alignment(0.64, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFD96C00),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 140,
                                height: 140,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      size: 80,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'LOGOUT',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // ALERTS
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }
}
