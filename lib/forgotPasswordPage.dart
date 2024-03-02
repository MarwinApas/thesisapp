import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  String? selectedQuestion;
  TextEditingController usernameController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Navigator.of(context).pop();
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
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 40),
                          Container(
                            width: 300,
                            alignment: Alignment.topCenter,
                            child: TextFormField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                hintText: "Enter Username",
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
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 300,
                            alignment: Alignment.topCenter,
                            child: TextFormField(
                              controller: answerController,
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
                                  return 'Answer is required';
                                }
                                return null;
                              },
                            ),
                          ), //pass
                          SizedBox(height: 30),
                          TextButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                // All fields are valid, handle verification action
                              }
                            },
                            child: Text(
                              "Verify",
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
    );
  }
}
