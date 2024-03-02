import 'package:flutter/material.dart';
import 'package:thesis_app/WelcomePage.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff02022d),
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
          "SETTINGS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              decoration: BoxDecoration(
                color: Color(0xE0FFFFFF), //Color(0xE0FFFFFF)
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.person_rounded,
                              size: 130,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Align the Row to the center
                        children: [
                          Text(
                            "HELLO, MARWIN JAKE APAS!",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5), // Add some space between text and icon
                          Icon(
                            Icons.edit,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox( height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text("ACCOUNT",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0x86262626),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            )
          ],
        ),
      ),
    );
  }
}
