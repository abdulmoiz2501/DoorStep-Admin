import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_admin/constants.dart';

import '../Login/login.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final splashDelay = 5;

  @override
  void initState() {
    super.initState();

    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    User? user=FirebaseAuth.instance.currentUser;
    if(user==null)
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage(onSignUpClicked: (){},),),);
    }
    else
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage(onSignUpClicked: (){},),),);
    }

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/splashclean.png',
                            height: size.height*0.7,
                            width: size.width*0.7,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                          ),
                        ],
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Text("DoorStep",style: TextStyle(
                    fontFamily: "Montserrat Medium",
                    fontSize: 28,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Text("Admin",style: TextStyle(
                    fontFamily: "Montserrat Medium",
                    fontSize: 24,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}