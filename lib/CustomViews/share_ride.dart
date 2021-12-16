
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:car_pool/main.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class ShareRide extends StatefulWidget{

  _ShareRide createState() => _ShareRide(
  );
}

class _ShareRide extends State<ShareRide> {
  late String departure;
  late String arrival;
  late String description;
  late String seats;
  late DateTime rideDate;
  bool status = false;

  GlobalKey<FormState> _rideKey = GlobalKey<FormState>();
  buildShareRide(){
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.white70]
            )
        ),
        child:new Form(
            key:_rideKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex:3,
                    child:  Image.asset(
                      'assets/images/sedan.png',
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      fit: BoxFit.scaleDown,
                    )
                  ),
                  Expanded(flex:2,
                    child:TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Departure Point',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_pin),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your starting location';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        departure = value!;
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
                        labelText: 'Arrival Point',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_pin),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your arrival point.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        arrival = value!;
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
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_pin),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your description';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        description = value!;
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
                        labelText: 'Available Seats',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_pin),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your available seat number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        seats = value!;
                      },
                    ), ),
                  Expanded(flex:1,
                    child: SizedBox(
                      height: 15,
                    ),),
                  Expanded(flex:2,
                    child: DateTimePickerFormField(
                      firstDate: DateTime.now(),
                      inputType: InputType.both,
                      format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
                      editable: false,
                      decoration: InputDecoration(
                          labelText: 'DateTime',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today_outlined),
                          floatingLabelBehavior: FloatingLabelBehavior.never
                      ),
                      onChanged: (dt) {
                        setState(() => rideDate = dt);
                      },
                      onSaved: (dt){
                        rideDate = dt;
                      }
                    ),
                  ),
                  Expanded(flex:1,
                    child: SizedBox(
                      height: 15,
                    ),),
                  Expanded(flex:2,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'Do you want to share a Taxi?',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.4),
                              fontSize: 24.0,
                            ),
                          ),
                        FlutterSwitch(
                            value: status,
                            borderRadius: 30.0,
                            padding: 8.0,
                            onToggle: (val) {
                              setState(() {
                                status = val;
                              }
                              ); }),
                      ],
                    ),
    ),
                  Expanded(flex:2,
                    child:Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          if (_rideKey.currentState!.validate()) {
                            _rideKey.currentState!.save();
                            createRide(context);
                          }
                        },
                        color: Colors.blue,
                        child: Text(
                          'Share this Ride',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ), ),

            ]
        )
    ),
    );
  }
  Future createRide(BuildContext context) async {
    var rd=rideDate.toString();
    var type;
    if(status==false){
      type="share-ride-owner";
    }
    else{
      type="share-taxi";
    }
    var body = {
      "departure_location":departure,
      "destination":arrival,
      "caption": description,
      "available_seats": seats,
      "ride_datetime":rd,
      "type":type,
    };
    var tkn=AuthObject.csrf;

    final response = await http.post(
      Uri.parse('http://ride-share-cs308.herokuapp.com/api/posts/'),
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization":"Token $tkn",
      },
      body: jsonEncode(body),
    );

    if(response.statusCode==201){
      print("Successfully posted");
      //Navigator.pop(context);
    }
    else {
      print(response.statusCode);
      print(response.body);
    }

  }

  Widget build(BuildContext context) {
    return buildShareRide(
    );
  }
}