import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? selectedQuestion;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final username = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  final verificationAnswer = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool newPasswordIsVisible = true, confirmPasswordIsVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Container(
                            width: 300,
                            alignment: Alignment.topCenter,
                            child: TextFormField(
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
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedQuestion = newValue;
                                });
                              },
                              style: TextStyle(
                                color: Colors.black, // Set the text color
                                fontSize: 20, // Set the text size
                              ),
                              icon: Icon(Icons.arrow_drop_down), // Set the dropdown icon
                              iconSize: 24, // Set the dropdown icon size
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
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                // All fields are valid, handle registration action
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
    );
  }
}
