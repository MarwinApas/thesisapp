import 'package:flutter/material.dart';
import 'package:thesis_app/JsonModels/users.dart';
import 'package:thesis_app/SQLite/database_helper.dart';
import 'package:thesis_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? selectedQuestion;
final db = DatabaseHelper();
final firstName = TextEditingController();
final lastName = TextEditingController();
final userName = TextEditingController();
final userPassword = TextEditingController();
final confirmUserPassword = TextEditingController();
final userVerificationQuestion = TextEditingController();
final userVerificationAnswer = TextEditingController();

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> registerUser() async {
  // Check if the username already exists in the database
  bool usernameExists = await db.checkUsernameExists(userName.text);
  QuerySnapshot query = await _firestore
      .collection('users')
      .where('userName', isEqualTo: userName.text)
      .get();

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
    try{
      await _firestore.collection('users').add(newUser.toMap());
      await db.createUser(newUser);

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
    }
    catch(e){
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
    Navigator.pop(context); // Navigate back to the previous screen after registration
  }
}



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
                  height: 600,
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
                              controller: firstName,
                              decoration: InputDecoration(
                                hintText: "First Name",
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
                              controller: lastName,
                              decoration: InputDecoration(
                                hintText: "Last Name",
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
                              controller: userName,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person),
                                hintText: "New Username",
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'A username is required';
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
                              controller: userPassword,
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
                              controller: confirmUserPassword,
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
                          Container(
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
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () async {
                              if (userPassword.text != confirmUserPassword.text) {
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
                                            confirmUserPassword.clear(); // Clear the confirm password field
                                          },
                                          child: Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
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
                                  int userId = await db.createUser(newUser);
                                  bool registrationSuccess = userId != -1; // Check if the user ID is valid
                                  if (registrationSuccess) {
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
                                  } else {
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
