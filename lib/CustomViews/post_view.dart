import 'package:car_pool/CustomViews/post_detail.dart';
import 'package:car_pool/Screens/profile.dart';
import 'package:flutter/material.dart';

class PostView extends StatefulWidget{

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
    required this.profilePhotoUrl,});

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
        profileDialog();
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

  void postDialog() {
    showDialog(builder: (BuildContext context) {
      return Card(
          margin: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width/6,vertical:MediaQuery.of(context).size.height/6),
          child: Card()/*PostDetail()*/
      );
    }, context: context);
  }
  void profileDialog() {
    showDialog(builder: (BuildContext context) {
      return Card(
          margin: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width/6,vertical:MediaQuery.of(context).size.height/6),
          child: ProfileDialog()
      );
    }, context: context);
  }

}
