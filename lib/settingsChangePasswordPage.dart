import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thesis_app/LoginPage.dart';
import 'package:thesis_app/SQLite/database_helper.dart';
import 'package:thesis_app/flutter/Settings.dart';
import 'package:thesis_app/main.dart';


class settingsChangePasswordPage extends StatefulWidget {


  @override
  _settingsChangePasswordPage createState() => _settingsChangePasswordPage();
}

class _settingsChangePasswordPage extends State<settingsChangePasswordPage> {
  final userName = TextEditingController();
  final newUserPassword = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value != newUserPassword.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  /*void changePassword() async {
    String username = userName.text.trim(); // Get the username of the current user
    String newPassword = newUserPassword.text.trim();
    if (username.isEmpty || newPassword.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Empty username or password."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return; // Exit the method if username or password is empty
    }

    bool passwordUpdated = await DatabaseHelper().updateUserPassword(username, newPassword);

    if (passwordUpdated) {
      // Password updated successfully, show a success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Password has been changed."),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigate to LoginPage
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false,
                  );
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      // Failed to update password, show an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to change password. Please try again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }*/

  //method to resetPassword
  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      // Password reset email sent successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent successfully!'),
        ),
      );
    } catch (e) {
      // Handle specific error cases
      String errorMessage = 'An error occurred. Please try again.';
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found with this email. Please check your email address.';
        } else {
          errorMessage = 'Error: ${e.message}';
        }
      }
      // Show error message in a SnackBar or dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }



  /*        */

  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>Settings())
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=>Settings())
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
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Container(
                    width: 400,
                    height: 350,
                    decoration: BoxDecoration(
                      color: Color(0x86262626),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Form(
                        //key: _formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 40),
                            Container(
                              width: 300,
                              alignment: Alignment.topCenter,
                              child: TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: "Enter Email",
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Username is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            TextButton(
                              onPressed: resetPassword,
                              child: Row(
                                children: [
                                  Icon(Icons.email),
                                  SizedBox(width: 10),
                                  Text(
                                    "Change Password",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
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
                                minimumSize: Size(250, 50),
                              ),
                            ),

                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
