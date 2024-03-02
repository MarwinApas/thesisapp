import 'package:flutter/material.dart';
import 'package:thesis_app/WelcomePage.dart';
import 'package:thesis_app/forgotPasswordPage.dart';
import 'package:thesis_app/main.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password =  TextEditingController();

  //variable to show and hide pass
  bool isVisible = true;
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
                    Navigator.of(context)
                        .push(
                        MaterialPageRoute(
                            builder: (context) => Home()
                        )
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
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 40),
                        Container(
                          width: 300, // Adjust the width as needed
                          alignment: Alignment.topCenter, // Adjust the alignment
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
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
                          width: 300, // Adjust the width as needed
                          child: TextFormField(
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
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              Navigator.of(context)
                                  .push(
                                  MaterialPageRoute(
                                      builder: (context) => WelcomePage()
                                  )
                              );
                            }
                          },
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
                                builder: (context) => ForgotPasswordPage(),
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
    );
  }
}
