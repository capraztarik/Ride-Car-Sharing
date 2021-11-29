

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class PostDetail extends StatefulWidget{

  _PostDetail createState() => _PostDetail(
  );
}
class _PostDetail extends State<PostDetail> {
  buildPostDetail(){

  }
  Widget build(BuildContext context) {
    return buildPostDetail(
       );
  }
}

class ProfileDialog extends StatefulWidget{

  _ProfileDialog createState() => _ProfileDialog();
}
class _ProfileDialog extends State<ProfileDialog> {
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
                child:  Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: DecorationImage(
                      image: NetworkImage('https://www.cumhuriyet.com.tr/Archive//2021/9/4/003750070-1b7c9867-b5d0-4da7-8bf2-42273401a36740995888-1.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all( Radius.circular(50.0)),
                    border: Border.all(
                      color: Colors.red,
                      width: 4.0,
                    ),
                  ),
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
  Widget build(BuildContext context) {
    return buildProfileCard(
    );
  }
}