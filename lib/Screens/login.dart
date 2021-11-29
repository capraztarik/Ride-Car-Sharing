import 'dart:convert';
import 'package:requests/requests.dart';
import 'package:car_pool/Screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Constants.dart';
import '../main.dart';
import 'feed.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}
int attemptCount = 0;
late String email;
late String pass;
 GlobalKey<FormState> _formKey = GlobalKey<FormState>();
late double login_card_width;
late double login_card_height;

late double sized_box_height;

class _LoginState extends State<Login> {

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
      login_card_width=MediaQuery.of(context).size.width/2;
    }
    else{
      login_card_width=MediaQuery.of(context).size.width/3;
    }
    if(MediaQuery.of(context).size.height<1200){
      login_card_height=MediaQuery.of(context).size.height/2;
      sized_box_height=4.0;
    }
    else{
      login_card_height=MediaQuery.of(context).size.height/2.5;
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
                    buildLoginCard(context),
                    SizedBox(height: sized_box_height),
                  ],
                )
            )
          ]
        ));
  }


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
 buildLoginCard (BuildContext context){
   /*if(MediaQuery.of(context).size.height<750 || MediaQuery.of(context).size.width<800){
     return Center(
       child:Card(
         color: Colors.blueGrey,
         child:Text("For Better Experience please use your browser in full screen size ",
           style: TextStyle(
             color: Colors.black.withOpacity(0.4),
             fontSize: 16.0,
           ),
         ),
       )
     );
   }*/
  return Container(
      width: login_card_width,
      height: login_card_height ,
   child:Card(
    color: Colors.blueGrey,
    child: new Container(
      padding: EdgeInsets.all(50.0),
      child: new Form(
        key:_formKey,
        child:Column(
            children: <Widget>[
              Expanded(flex:2,
                child:TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your e-mail';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                },
              ),),
              Expanded(flex:1,
                  child:SizedBox(
                    height: sized_box_height,
                  ),),
              Expanded(flex:2,
                  child:TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: Icon(Icons.remove_red_eye),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      pass = value!;
                    },
                  ),),
              Expanded(flex:1,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () { //Develop forget password page TODO
                          print('Forgotted Password!');
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.4),
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),),
              Expanded(flex:1,
                  child:SizedBox(
                    height: sized_box_height,
                  ),),
              Expanded(flex:3,
                  child:Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          loginUser(email,pass,context);
                        }
                      },
                      color: Colors.blue,
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),),
              Expanded(flex:1,
                  child:SizedBox(
                    height: sized_box_height,
                  ),),
              Expanded(flex:1,
                  child:Divider(
                    color: Colors.black,
                    height: 30,
                  ),),
              Expanded(flex:1,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '''Don't have an account? ''',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 16.0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ),
                          );
                        },
                        child: Text('Register Now'),
                      )
                    ],
                  ),
              ),

        ],
      ),
   ),
   )
  ),);
}
Future<Map<String, dynamic>> loginUser(String email, String password,BuildContext context) async {
  var result;

  var loginData = {
    'email': email,
    'password': password
  };
  final response = await http.post(
    Uri.parse('http://ride-share-cs308.herokuapp.com/api/users/login/'),
    headers:{
      'Content-Type': 'application/json; charset=UTF-8',
      "Access-Control-Allow-Origin": "*"
    },
    body: jsonEncode(loginData),
  );

  final Map<String, dynamic> responseData = json.decode(response.body);
  if(response.statusCode==200){
    print("Successfully Login");
    var userData = responseData['token'];
    AuthObject.csrf = responseData['token'];
    print(AuthObject.csrf);
    AuthObject.userEmail=email;
    print(AuthObject.userEmail);
    /*User authUser = User.fromJson(userData);*/
    /*UserPreferences().saveUser(authUser);*/
    result = {
      'status': true,
      'message': 'Successfully registered',
    };
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Feed(),
      ),
    );
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

class EmailValidator {
  static bool? validate(String value) {}
}
