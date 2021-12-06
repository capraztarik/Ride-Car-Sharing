// @dart=2.9
import 'package:car_pool/Screens/signup.dart';
import 'package:car_pool/Screens/verification.dart';
import 'package:flutter/material.dart';
import 'Screens/feed.dart';
import 'Screens/login.dart';
import 'Screens/profile.dart';
import 'package:flutter_switch/flutter_switch.dart';

Size screenSize;
void main() {
  runApp(MyApp());
}
class AuthObject{
  static String csrf;
  static String userName;
  static String userEmail;
  static String phoneNumber;
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/feed': (context) => Feed(),
        '/login': (context) => Login(),
        '/signup': (context) => SignUp(),
        '/verification': (context) => Verification(),
        /*'/profile': (context) => Profile(),*/
      },
    );
  }
}