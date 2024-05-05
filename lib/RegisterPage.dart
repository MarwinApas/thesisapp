import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thesis_app/JsonModels/users.dart';
import 'package:thesis_app/SQLite/database_helper.dart';
import 'package:thesis_app/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:thesis_app/firebase_auth_implemention/firebase_auth_services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  String? selectedQuestion;
  final db = DatabaseHelper();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController confirmUserPasswordController = TextEditingController();
  TextEditingController userVerificationQuestion = TextEditingController();
  TextEditingController userVerificationAnswer = TextEditingController();
  //TextEditingController userKey = TextEditingController();

  //for firestore
  /*Future<void> addUserDetails(String firstName, String lastName) async {
    await FirebaseFirestore.instance.collection('owners_collection').add({
      'firstName': firstName,
      'lastName': lastName,
    });
  }*/

  void dispose(){
    fullNameController.dispose();
    emailController.dispose();
    userNameController.dispose();
    userPasswordController.dispose();
    confirmUserPasswordController.dispose();
    userVerificationQuestion.dispose();
    userVerificationAnswer.dispose();
    //userKey.dispose();
    super.dispose();
  }




  //registerAcc
  void _signUp() async {
    String userName = userNameController.text;
    String email = emailController.text;
    String password = userPasswordController.text;
    String fullName = fullNameController.text;

    try {
      User? user = await _auth.signUpWithEmailAndPassword(email, password);
      if (user != null) {
        // Registration successful
        String userEmail = email.substring(0,email.indexOf('@'));
        addUserDetails(userEmail, email, fullName);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Registration successful!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception("Registration failed unexpectedly.");
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Registration unsuccessful. Please try again."),
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

  //for realtime database
  Future<void> addUserDetails(String userEmail,String email, String fullName) async {
    DatabaseReference reference = FirebaseDatabase.instance.ref()
        .child('owners_collection')
        .child(userEmail)
        .child('user_data');
    await reference.set({
      'userName': userEmail,
      'email': email,
      'fullName': fullName,
    });

  }

  //for settings


  //for firestore database
 /* Future<void> addUserDetailsFireStore(String userName,String email, String fullName) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection("owners_collection").doc("1").set({
      "Username": userName,
      "Email": email,
      "Fullname":fullName
    });
  }*/

  /*Future<void> registerUser() async {
    // Check if the username already exists in the database

    bool usernameExists = await db.checkUsernameExists(userName.text);

    if (usernameExists) {
      // Username already exists, display an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Username already exists. Please type a different username."),
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
      // Username is unique, proceed with user registration
      final newUser = Users(
        firstName: firstName.text,
        lastName: lastName.text,
        userName: userName.text,
        userPassword: userPassword.text,
        userVerificationQuestion: userVerificationQuestion.text,
        userVerificationAnswer: userVerificationAnswer.text,
      );

      try {
        await db.createUser(newUser);
        await addUserDetails(userName.text.trim(), firstName.text.trim(), lastName.text.trim());
        //await saveUserKeyToSharedPreferences(userKey);
        //print("NEW USER KEY: $userKey");4
        // Display success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Registration successful!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.pop(context, true); // Navigate back with success flag
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } catch (e) {

        // Display error dialog for unsuccessful registration
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Registration unsuccessful. Please try again."),
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

  //final formKey = GlobalKey<FormState>();
  bool newPasswordIsVisible = true, confirmPasswordIsVisible = true;

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0xFFDEDFDF),
      ),
      body: Stack(
        children: [
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
                child: Container(
                  width: 360,
                  height: 450,
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
                          SizedBox(height: 10),
                          Container(
                            width: 300,
                            alignment: Alignment.topCenter,
                            child: TextFormField(
                              controller: fullNameController,
                              decoration: InputDecoration(
                                hintText: "Enter Full name",
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 300,
                            alignment: Alignment.topCenter,
                            child: TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: "Email address",
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 300,
                            alignment: Alignment.topCenter,
                            child: TextFormField(
                              controller: userPasswordController,
                              obscureText: newPasswordIsVisible,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      //toggle button
                                      newPasswordIsVisible = !newPasswordIsVisible;
                                    });
                                  }, icon: Icon(newPasswordIsVisible?Icons.visibility_off:Icons.visibility),
                                ),
                                hintText: "New Password",
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'A password is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 300,
                            alignment: Alignment.topCenter,
                            child: TextFormField(
                              controller: confirmUserPasswordController,
                              obscureText: confirmPasswordIsVisible,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      //toggle button
                                      confirmPasswordIsVisible = !confirmPasswordIsVisible;
                                    });
                                  }, icon: Icon(confirmPasswordIsVisible?Icons.visibility_off:Icons.visibility),
                                ),
                                hintText: "Confirm Password",
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          /*Container(
                            width: 300,
                            alignment: Alignment.centerLeft,
                            child: DropdownButton<String>(
                              hint: Text("Verification Question"),
                              value: selectedQuestion,
                              onChanged: (String? newValue) async {
                                setState(() {
                                  selectedQuestion = newValue;
                                });
                                if (newValue != null) {
                                  // Store the selected question in your userVerificationQuestion TextEditingController
                                  userVerificationQuestion.text = newValue;
                                  // You can also directly update your newUser object if it's accessible here
                                  // newUser.userVerificationQuestion = newValue;
                                }
                                else{
                                }
                              },
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              items: <String>[
                                'What is your favorite color?',
                                'What is your pet\'s name?',
                                'What city were you born in?',
                                // Add more items as needed
                              ].map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 300,
                            alignment: Alignment.topCenter,
                            child: TextFormField(
                              controller: userVerificationAnswer,
                              decoration: InputDecoration(
                                hintText: "Answer",
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 10),*/
                          TextButton(
                            onPressed: () async {
                              if (userPasswordController.text != confirmUserPasswordController.text) {
                                // Display error alert dialog for password mismatch
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Error"),
                                      content: Text("The password does not match. Please try again."),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context); // Close the dialog
                                            confirmUserPasswordController.clear(); // Clear the confirm password field
                                          },
                                          child: Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                try {
                                  _signUp();
                                  //await registerUser(); // Call the registerUser function
                                  // User registration successful, navigate back or perform any other action
                                } catch (e) {
                                  // Display error dialog for unsuccessful registration
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content: Text("Registration unsuccessful. Please try again."),
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
                            },
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "REGISTER",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: .5,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
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
