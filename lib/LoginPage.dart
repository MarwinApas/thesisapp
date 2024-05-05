import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thesis_app/JsonModels/users.dart';
import 'package:thesis_app/SQLite/database_helper.dart';
import 'package:thesis_app/WelcomePage.dart';
import 'package:thesis_app/changePasswordPage.dart';
import 'package:thesis_app/firebase_auth_implemention/firebase_auth_services.dart';
import 'package:thesis_app/forgotPasswordPage.dart';
import 'package:thesis_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  String? loggedInUsername;
  TextEditingController emailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  final userPassword = TextEditingController();
  final db = DatabaseHelper();

  bool isLoginTrue = false;
  bool isVisible = true;

  /*Future<void> login() async {
    // Check if the username exists
    bool usernameExists = await db.checkUsernameExists(userName.text);

    if (!usernameExists) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Username does not exist. please try again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      var res = await db.authenticate(Users(userName:userName.text,userPassword:userPassword.text));
      if (res == true) {
        if (!mounted) return;
        loggedInUsername = userName.text;
        Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage(/*userName:loggedInUsername*/)));

        // Save the username to SharedPreferences after successful login
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userName', userName.text); // Save the username
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Incorrect username or password. Please try again."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }*/


  //loginacc
  void _signIn() async {
    String email = emailController.text;
    String password = userPasswordController.text;

    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        String userName = email.substring(0,email.indexOf('@'));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userName', userName); // Save the username for realtime database
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Login successful!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage()));
                  },
                  child: Text(""),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage()));
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception("Login failed unexpectedly.");
      }
    } catch (e) {
      // Handle registration errors
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Incorrect username or password. please try again."),
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
  }

  /*void _signIn() async{
    String email = emailController.text;
    String password = userPasswordController.text;
  }*/

  @override
  Widget build(BuildContext context) { // Implement build method
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>Home())
        );
        return false;
      },
    child: Scaffold(
      backgroundColor: Color(0xE0FFFFFF),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
                    );
                  },
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "«",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xE0FFFFFF),
                    shape: CircleBorder(),
                    side: BorderSide(
                      color: Colors.black,
                      width: 3,
                    ),
                    minimumSize: Size(40, 50),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Container(
                width: 400,
                height: 300,
                decoration: BoxDecoration(
                  color: Color(0x86262626),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Form(
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 40),
                        Container(
                          width: 300, // Adjust the width as needed
                          alignment: Alignment.topCenter, // Adjust the alignment
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              hintText: "Enter Email address",
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 300, // Adjust the width as needed
                          child: TextFormField(
                            controller: userPasswordController,
                            obscureText: isVisible,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    //toggle button
                                    isVisible = !isVisible;
                                  });
                                }, icon: Icon(isVisible?Icons.visibility_off:Icons.visibility),
                              ),
                              hintText: "Enter Password",
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: _signIn,

                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xE0FFFFFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            minimumSize: Size(190, 50),
                          ),
                        ),
                        SizedBox(height: 2),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => changePasswordPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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

}


