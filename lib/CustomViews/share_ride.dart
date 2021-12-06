

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:car_pool/main.dart';
import 'package:flutter_switch/flutter_switch.dart';

class ShareRide extends StatefulWidget{

  _ShareRide createState() => _ShareRide(
  );
}

class _ShareRide extends State<ShareRide> {
  late String departure;
  late String arrival;
  late String description;
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

  Widget build(BuildContext context) {
    return buildShareRide(
    );
  }
}