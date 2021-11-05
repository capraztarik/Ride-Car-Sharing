import 'package:flutter/material.dart';

import 'login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}
int attemptCount = 0;
late String email;
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

  Future<void> SignUpUser() async {

  }

  Widget build(BuildContext context) {
    if(MediaQuery.of(context).size.width<1500){
      SignUp_card_width=MediaQuery.of(context).size.width/2;
    }
    else{
      SignUp_card_width=MediaQuery.of(context).size.width/3;
    }
    if(MediaQuery.of(context).size.height<1200){
      SignUp_card_height=MediaQuery.of(context).size.height/2;
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
  if(MediaQuery.of(context).size.height<900 || MediaQuery.of(context).size.width<850){
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
  }
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
              children: <Widget>[
                TextFormField(
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
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
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
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
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
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
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
                        signUpUser();
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
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(
                  color: Colors.black,
                  height: 30,
                ),
                Row(
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
                ),
              ],
            ),
          ),
        )
    ),);
}

void signUpUser() {
  if(pass!=pass2){
    print("Passwords dont match");
  }
  else{
  print(email);
  print(pass);}
}

class EmailValidator {
  static bool? validate(String value) {}
}
