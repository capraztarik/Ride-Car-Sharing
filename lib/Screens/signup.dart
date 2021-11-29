import 'dart:convert';
import 'package:car_pool/Constants.dart';
import 'package:car_pool/Models/user.dart';
import 'package:car_pool/Screens/verification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}
int attemptCount = 0;
late String email;
late String name;
late String surname;
late String pass;
late String pass2;
 GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
late double SignUp_card_width;
late double SignUp_card_height;


class _SignUpState extends State<SignUp> {

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
      SignUp_card_width=MediaQuery.of(context).size.width/2;
    }
    else if(MediaQuery.of(context).size.width<850){
      SignUp_card_width=MediaQuery.of(context).size.width;
    }
    else{
      SignUp_card_width=MediaQuery.of(context).size.width/3;
    }
    if(MediaQuery.of(context).size.height<1200){
      SignUp_card_height=MediaQuery.of(context).size.height/2;
    }
    else if(MediaQuery.of(context).size.height<850) {
      SignUp_card_height=MediaQuery.of(context).size.height;
    }
    else{
      SignUp_card_height=MediaQuery.of(context).size.height/(2.5);
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
                      SizedBox(height: 15),
                      buildSignUpCard(context),
                      SizedBox(height: 15),
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
buildSignUpCard (BuildContext context){
  /*if(MediaQuery.of(context).size.height<800 || MediaQuery.of(context).size.width<800){
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
    width: SignUp_card_width,
    height: SignUp_card_height ,
    child:Card(
        color: Colors.blueGrey,
        child: new Container(
          padding: EdgeInsets.all(50.0),
          child: new Form(
            key:_signUpKey,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(flex:2,
                  child:TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!;
                    },
                  ), ),
                Expanded(flex:1,
                  child: SizedBox(
                    height: 15,
                  ),),
                Expanded(flex:2,
                  child:TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      surname = value!;
                    },
                  ), ),
                Expanded(flex:1,
                  child: SizedBox(
                    height: 15,
                  ),),
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
                ), ),
              Expanded(flex:1,
                child:SizedBox(
                  height: 15,
                ), ),
                Expanded(flex:2,
                    child: TextFormField(
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
                          return 'Please enter your pass';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        pass = value!;
                      },
                    ),),
                Expanded(flex:1,
                    child: SizedBox(
                      height: 15,
                    ),),

                Expanded(flex:2,
                    child:TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Please type your password again',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: Icon(Icons.remove_red_eye),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your e-mail';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        pass2 = value!;
                      },
                    ), ),
                Expanded(flex:1,
                    child:SizedBox(
                      height: 15,
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
                          if (_signUpKey.currentState!.validate()) {
                            _signUpKey.currentState!.save();
                            signUpValidations(context);
                          }
                        },
                        color: Colors.blue,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ), ),
                Expanded(flex:1,
                    child: SizedBox(
                      height: 15,
                    ),),
                Expanded(flex:1,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '''Do you already have an account? ''',
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
                                builder: (context) => Login(),
                              ),
                            );
                          },
                          child: Text('Login Now'),
                        )
                      ],
                    ), ),

              ],
            ),
          ),
        )
    ),);
}
Future signUpUser(BuildContext context) async {
  var result;

  var body = {
    "first_name":name,
    "last_name":surname,
    "password": pass,
    "email": email
  };
  /*final response = await http.post(
    Uri.http('ride-share-cs308.herokuapp.com', '/api/users/register/'),
    headers:{
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
    },
    body: body,
    encoding: Encoding.getByName("utf-8"),
  );*/
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
    AuthObject.csrf = responseData['token'];
    print(AuthObject.csrf);
    AuthObject.userEmail=email;
    print(AuthObject.userEmail);

    /*UserPreferences().saveUser(authUser);*/
    result = {
      'status': true,
      'message': 'Successfully registered',
    };
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Verification(),
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

}

void signUpValidations(BuildContext context) {

  if(pass!=pass2){
    print("Passwords don't match");
  }
  else{
    signUpUser(context);
  }
}

class EmailValidator {
  static bool? validate(String value) {}
}
