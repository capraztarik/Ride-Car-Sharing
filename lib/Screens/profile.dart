import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:car_pool/CustomViews/post_view.dart';
import 'package:car_pool/Models/post_model.dart';
import 'package:flutter/material.dart';

import 'feed.dart';
import 'login.dart';
/*
class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}
class _Profile extends State<Profile>{
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }
  Future<void> initialFunction() async {

  }
  dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: TextButton(onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Feed(),
              ),
            );
          },
              child: Text(
            "Car Pool",
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
          ),

          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.search,
                    size: 26.0,
                  ),
                )
            ),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child:InkWell(
                  onTap: () {logOut();},
                  child: Icon(
                    Icons.logout,
                    size: 26.0,
                  ),
                )
            ),
          ],
        ),
        body:Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 2,
                child: Card(),
              ),
              Expanded(
                flex: 4,
                child: buildProfileCard(),
              ),
              Expanded(
                flex: 2,
                child: Card(),
              ),
            ],
          ),
        );
    }



  Future logOut() async {
    var result;

    final response = await http.post(
      Uri.parse('http://ride-share-cs308.herokuapp.com/api/users/logout/'),
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*"
      },
    );
    final Map<String, dynamic> responseData = json.decode(response.body);

    if(response.statusCode==204){
      print("Successfully Logout");
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
    }
    else {
      print(response.statusCode);
    }
  }
}*/
buildProfileCard() {
  return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlueAccent, Colors.blueAccent]
          )
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex:3,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://img.fanatik.com.tr/img/78/740x418/6131c8e966a97c1bc05b80ae.jpg",
                ),
                radius: 500.0,
              ),
            ),
            Expanded(
              flex:1,
              child: Text(
                'Miralem Pjanic',
                style: TextStyle(
                  fontSize: 34,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              flex:2,
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 50.0),
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
                  child: Row(
                      children: <Widget>[
                        Expanded(
                            flex:1,
                            child:Text(
                              "Total Rides",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                        ),
                        Expanded(
                            flex:1,
                            child:Text(
                              "50",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22.0,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                        ),
                        Expanded(
                            flex:1,
                            child:Text(
                              "Driver Rating",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                        ),
                        Expanded(
                            flex:1,
                            child:Text(
                              "%97",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 22.0,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                        ),
                      ]
                  ),
                ),
              ),
            ),
            Expanded(
                flex:1,
                child: SizedBox(
                    height:10
                )
            ),





          ]
      )
  );
}
