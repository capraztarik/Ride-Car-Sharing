import 'package:car_pool/CustomViews/post_detail.dart';
import 'package:car_pool/Screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

class PostView extends StatefulWidget{
  final int id;
  final String owner;
  final String type;
  final int available_seats;
  final String departure_location;
  final String destination;
  final String caption;
  final String ride_datetime;
  final String post_datetime;
  final bool is_full;
  final int remaining_seats;
  final String profilePhotoUrl;


  const PostView(
      {
        required this.id,
        required this.owner,
        required this.type,
        required this.available_seats,
        required this.departure_location,
        required this.destination,
        required this.caption,
        required this.ride_datetime,
        required this.post_datetime,
        required this.is_full,
        required this.remaining_seats,
        required this.profilePhotoUrl,
      });

  _PostView createState() => _PostView(
    owner: this.owner,
    caption: this.caption ,
    profilePhotoUrl: this.profilePhotoUrl ,
    type: this.type,
    id:this.id,
    available_seats:this.available_seats,
    departure_location:this.departure_location,
    destination:this.destination,

    ride_datetime:this.ride_datetime,
    post_datetime:this.post_datetime,
    is_full:this.is_full,
    remaining_seats:this.remaining_seats,
     );
}

class _PostView extends State<PostView> {
  final String owner;
  final String type;
  final int id;
  final int available_seats;
  final String departure_location;
  final String destination;
  final String caption;
  final String ride_datetime;
  final String post_datetime;
  final bool is_full;
  final int remaining_seats;
  final String profilePhotoUrl;



  _PostView({required this.owner, required this.caption, required this.type,
    required this.available_seats,required this.departure_location,
    required this.destination, required this.ride_datetime, required this.post_datetime,
    required this.is_full,required this.remaining_seats,
    required this.profilePhotoUrl,
    required this.id,});

  buildImage(String type){
    if(type =="share-taxi"){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/taxi.png',
            //width: MediaQuery.of(context).size.width,
            height: 150,
            width: 300,
            fit: BoxFit.fitWidth,
          ),
          Text("Share a Taxi Drive",
              style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w400,
                  fontSize: 20))
        ],
      );
    }
    else
      {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/sedan.png',
              //width: MediaQuery.of(context).size.width,
              height: 150,
              width: 300,
              fit: BoxFit.fitWidth,
            ),
            Text("Share Personal Drive",
                style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w400,
                    fontSize: 20))
          ],
        );
      }

  }
  buildPostHeader({required String username, required String profilePhotoUrl}) {
    return InkWell(
      child: ListTile(
          leading: CircleAvatar(
              backgroundImage: NetworkImage(profilePhotoUrl),
              backgroundColor: Colors.grey,
            ),
          title:Text(username,
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 20)),
          //subtitle: Text(""),
          trailing: PopupMenuButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            itemBuilder: (context) {
              List<PopupMenuEntry<Object>> list = [];
                list.add(PopupMenuItem(child: Text("Report User"), value: "report"));
              return list;
            },
            icon: Icon(Icons.menu, size: 25),
            onSelected: (value) {
              if (value == "report") {
                //report
                print("report pressed");
              } else {
              }
            },
          )),
      onTap: () {
        profileDialog(username,profilePhotoUrl);
      },
    );
  }
  buildClickableBody({required String caption,required String departure,required String destination,required String ride_datetime,}) {
    DateTime rideDate =DateTime.parse(ride_datetime);
    return InkWell(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:<Widget>[
              Flexible(
                  flex:2,
                  child:buildImage(type)),
              Flexible(
                  flex:4,
                  child:
                  Column(
                      children:<Widget>[
                        Text(rideDate.toString().substring(0,16),
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        Text(departure + "-" +destination ,
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        Text(caption,
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.normal,
                                fontSize: 12)),
                      ]
                  ) ),
              Flexible(
                  flex:2,
                  child:
                  Column(children:<Widget>[
                    Text(remaining_seats.toString()+" Available Seat",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.normal,
                            fontSize: 12)),
                    TextButton(onPressed: (){
                      //TODO MAKE Reservation check choose
                      makeReservation(context);
                    }, child: Text('Rezervasyon Yap')),
                  ])),

            ]
        ),
      onTap: () {
       postDialog();
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        margin: EdgeInsets.only(bottom:20),
        child:Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
    buildPostHeader(username: this.owner, profilePhotoUrl: this.profilePhotoUrl),
    buildClickableBody(caption: this.caption,departure: this.departure_location,destination:this.destination,ride_datetime:this.ride_datetime),
        ],
        ));
  }

  Future makeReservation(BuildContext context) async {

    var tkn=AuthObject.csrf;

    final response = await http.post(
      Uri.parse('http://ride-share-cs308.herokuapp.com/api/posts/'+id.toString()+"/participate/"),
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization":"Token $tkn",
      },
    );

    if(response.statusCode==200){
      print("Successfully reserved");
    }
    else {
      print(response.statusCode);
      print(response.body);
    }

  }

  void postDialog() {
    showDialog(builder: (BuildContext context) {
      return Card(
          margin: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width/6,vertical:MediaQuery.of(context).size.height/6),
          child: Card()/*PostDetail()*/
      );
    }, context: context);
  }
  void profileDialog(String username,  String profilePhotoUrl) {
    showDialog(builder: (BuildContext context) {
      return Card(
          margin: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width/6,vertical:MediaQuery.of(context).size.height/6),
          child: buildProfileCard( username,   profilePhotoUrl)
      );
    }, context: context);
  }
  Container buildProfileCard(String username, String profilePhotoUrl) {
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
                      image: NetworkImage(profilePhotoUrl),
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
                  username,
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

}
