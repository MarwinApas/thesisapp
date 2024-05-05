import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thesis_app/SQLite/database_helper.dart';
import 'package:thesis_app/changeUsernamePage.dart';
import 'package:thesis_app/flutter/Alerts.dart';
import 'package:thesis_app/flutter/Tracker.dart';
import 'package:thesis_app/LoginPage.dart';
import 'package:thesis_app/WelcomePage.dart';
import 'package:thesis_app/main.dart';
import 'package:thesis_app/settingsChangePasswordPage.dart';

class Settings extends StatefulWidget {
  final String? userName; // Add this line to declare the userName parameter
  const Settings({Key? key, this.userName}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String firstName = '';
  String lastName = '';
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }



  //method to delete the account
  Future<void> deleteAccount() async{
    try{
      User? user = FirebaseAuth.instance.currentUser;
      if(user!=null){
        String userName = await GetuserName();
        deleteUsernameData(userName);
        await user.delete();
        
      }
    }catch(e){
    print("Error: ${e}");
    }
    //addananan pag logic para ma delete ang content sa database
  }
  void deleteUsernameData(String userName) {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref()
    .child('owners_collection')
    .child(userName);
    databaseReference.remove().then((_) {
      print('Data deleted successfully for username: $userName');
    }).catchError((error) {
      print('Failed to delete data: $error');
    });
  }
  Future<String> GetuserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName') ?? '';
  }
  //todo implement a update name
  Future<String?> getFullName(String userName) async {
    DatabaseReference fullNameRef = FirebaseDatabase.instance.reference()
        .child('owners_collection')
        .child(userName) // Assuming 'userName' is the key for the user's data
        .child('user_data')
        .child('fullName');

    try {
      DataSnapshot dataSnapshot = await fullNameRef.get();
      if (dataSnapshot.exists && dataSnapshot.value != null) {
        return dataSnapshot.value.toString();
      } else {
        print('Full Name not found for user: $userName');
        return null;
      }
    } catch (e) {
      print('Error getting Full Name: $e');
      return null;
    }
  }

  Future<void> updateFullName(String userName, String fullName) async {
    try {
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref()
          .child('owners_collection')
          .child(userName)
          .child('user_data')
          .child('fullName');

      await databaseReference.set(fullName);

      print('Full name updated successfully');
    } catch (e) {
      print('Error updating full name: $e');

    }
  }

  /*Future<String?> getFullName() async {
    String userName = GetuserName() as String;
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref()
        .child('owners_collection')
        .child(userName)
        .child('user_data')
        .child('fullName');

    try {
      DataSnapshot dataSnapshot = await databaseReference.get();
      if (dataSnapshot.exists && dataSnapshot.value != null) {
        return dataSnapshot.value.toString();
      } else {
        print('FullName not found for user: $userName');
        return null;
      }
    } catch (e) {
      print('Error getting FullName: $e');
      return null;
    }
  }*/




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff02022d),
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
          "SETTINGS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body:Column(
        children:
        [
          Container(
          width: MediaQuery.of(context).size.width,
          height: 250,
          decoration: BoxDecoration(
            color: Color(0xE0FFFFFF),
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
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Edit Full Name"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: fullNameController,
                                    decoration: InputDecoration(
                                      labelText: 'New Full Name',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    String userName = await GetuserName();
                                    String newFullName = fullNameController.text;
                                    await updateFullName(userName, newFullName);
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: Text("Save"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FutureBuilder<String?>(
                            future: GetuserName(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error loading user name');
                              } else {
                                String userName = snapshot.data ?? '';
                                return FutureBuilder<String?>(
                                  future: getFullName(userName),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error loading Full Name');
                                    } else {
                                      String? fullName = snapshot.data;
                                      return Text(
                                        "HELLO, ${fullName != null ? fullName.toUpperCase() : 'USER'} !",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.edit,
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
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 25,
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Text(
              "  ACCOUNT",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0x86262626),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => settingsChangePasswordPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "CHANGE PASSWORD",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.arrow_right),
              ],
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "LOGOUT",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.logout),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 25,
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Text(
              "",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0x86262626),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("DELETE ACCOUNT"),
                    content: Text("ARE YOU SURE THAT YOU WANT TO DELETE YOUR ACCOUNT?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("NO"),
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("DELETE ACCOUNT(2)"),
                                content: Text("ARE YOU SURE THAT YOU WANT TO DELETE YOUR ACCOUNT?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("NO"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deleteAccount();
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("ACCOUNT DELETED!"),
                                            content: Text("THE ACCOUNT HAS BEEN DELETED."),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                                                },
                                                child: Text("EXIT"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text("YES"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text("YES"),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "DELETE ACCOUNT",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SizedBox(),
          ),
          Container(
            height: 90,
            color: Color(0xff02022d),
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
                        Icons.settings,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'SETTINGS',
                        style: TextStyle(color: Colors.white, fontSize: 12.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}