// @dart=2.9
import 'package:flutter/material.dart';
import 'Screens/feed.dart';

Size screenSize;
void main() {
  runApp(MyApp());
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
      home: Feed(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/feed': (context) => Feed(),
      },
    );
  }
}