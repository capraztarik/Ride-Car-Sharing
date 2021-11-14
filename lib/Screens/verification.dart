import 'dart:async';
import 'dart:convert';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:car_pool/Screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Constants.dart';
import 'feed.dart';

class Verification extends StatefulWidget {
  @override
  _verificationState createState() => _verificationState();
}

bool hasError = false;
String currentText = "";
GlobalKey<FormState> _verifyKey = GlobalKey<FormState>();
late double verification_card_width;
late double verification_card_height;

late double sized_box_height;

class _verificationState extends State<Verification> {
  @override
  void initState() {
    super.initState();

  }
  Future<void> showAlertDialog(String title, String message) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, //User must tap button
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(message),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    if(MediaQuery.of(context).size.width<1500){
      verification_card_width=MediaQuery.of(context).size.width/2;
    }
    else{
      verification_card_width=MediaQuery.of(context).size.width/3;
    }
    if(MediaQuery.of(context).size.height<1200){
      verification_card_height=MediaQuery.of(context).size.height/2;
      sized_box_height=4.0;
    }
    else{
      verification_card_height=MediaQuery.of(context).size.height/2.5;
      sized_box_height=20.0;
    }
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black45,
        body: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 1,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background_login.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                  child:Column(
                    children: [
                      buildLogo(context),
                      SizedBox(height: sized_box_height),
                      buildVerificationCard(context),
                      SizedBox(height: sized_box_height),
                    ],
                  )
              )
            ]
        ));
  }



buildLogo(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width/4,
    height: MediaQuery.of(context).size.height/4 ,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey, width: 2),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(50),
      color: Colors.white,
      image: DecorationImage(
        fit: BoxFit.fitWidth,
        image: AssetImage('assets/images/Ride.png'),
      ),
    ),
  );

}
StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();
TextEditingController textEditingController = TextEditingController();
buildVerificationCard (BuildContext context){
  return Container(
    width: verification_card_width,
    height: verification_card_height ,
    child:Card(
        color: Colors.blueGrey,
        child: new Container(
          padding: EdgeInsets.all(50.0),
          child: new Form(
            key:_verifyKey,
            child:Column(
              children: <Widget>[
                Expanded(
                  flex:1,
                  child: Text(
                      "We just need to verify your email address \n\n"
                      "Please enter the code that we send you via Email",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                      ),textAlign: TextAlign.center,)
                ),
                Expanded(flex:1,
                child:PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    activeColor: Colors.black,
                    inactiveColor: Colors.black,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.blueGrey,
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  controller: textEditingController,
                  onCompleted: (code) {
                    validateUser(code);
                  },
                  onChanged: (value) {
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  }, appContext: context,
                )
                ),// end Padding()

              ],
            ),
          ),
        )
    ),);
}
Future<Map<String, dynamic>> verification(String email, String password) async {
  var result;

  final Map<String, dynamic> verificationData = {
    'user': {
      'email': email,
      'password': password
    }
  };
  final response = await http.post(
    Uri.parse('http://ride-share-cs308.herokuapp.com/api/users/verification/'),
    headers:{
      'Content-Type': 'application/json; charset=UTF-8',
      "Access-Control-Allow-Origin": "*"
    },
    body: jsonEncode(verificationData),
  );

  final Map<String, dynamic> responseData = json.decode(response.body);

  if(response.statusCode==200){
    print("Successfully verification");
    var userData = responseData['data'];
    /*User authUser = User.fromJson(userData);*/
    /*UserPreferences().saveUser(authUser);*/
    result = {
      'status': true,
      'message': 'Successfully registered',
    };
  }
  else {
    print(response.statusCode);
    print(response.body);
    result = {
      'status': false,
      'message': 'Registration failed',
      'data': responseData
    };
  }
  return result;
}
}
Future<http.Response> validateUser(String code) async {
  var result;
  var body = {
    "verifyCode": code,
    "email": email
  };
  final response = await http.post(
    Uri.parse('http://ride-share-cs308.herokuapp.com/api/users/register/'),
    headers:{
      'Content-Type': 'application/json; charset=UTF-8',
      "Access-Control-Allow-Origin": "*"
    },
    body: jsonEncode(body),
  );

  final Map<String, dynamic> responseData = json.decode(response.body);

  if(response.statusCode==201){
    print("Successfully Registered");
    var userData = responseData['data'];
    result = {
      'status': true,
      'message': 'Successfully registered',
    };
  }
  else {
    print(response.statusCode);
    print(response.body);
    result = {
      'status': false,
      'message': 'Registration failed',
      'data': responseData
    };
  }

  return result;
}
