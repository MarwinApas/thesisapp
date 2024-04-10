import 'package:flutter/material.dart';
import 'package:thesis_app/LoginPage.dart';
import 'package:thesis_app/RegisterPage.dart';


void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Home(),
));

class Home extends StatelessWidget {
  const Home({Key? key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
    child:Scaffold(
        backgroundColor: Color(0xE0FFFFFF),
        body: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "AUTOMATIC\nMONEY\nCHANGER",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: .5,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(70.0),
                child: Container(
                  // Change the color here
                  width: 250,
                  height: 200,
                  decoration: BoxDecoration(
                    color:Color(0x86262626),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()
                              )
                          );
                        },
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "LOGIN",
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
                            borderRadius:  BorderRadius.circular(10),
                          ),
                          side: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          minimumSize: Size(190,50),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()
                              )
                          );
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
                            borderRadius:  BorderRadius.circular(10),
                          ),
                          side: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          minimumSize: Size(190,50),
                        ),
                      ),
                      SizedBox(height: 2.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
          )
        ),
      ),
    );
  }
}