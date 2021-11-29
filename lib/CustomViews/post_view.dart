import 'package:car_pool/CustomViews/post_detail.dart';
import 'package:car_pool/Screens/profile.dart';
import 'package:flutter/material.dart';

class PostView extends StatefulWidget{
  final String username;
  final String uid;
  final String pid;
  final String caption;
  final String location;
  final String profilePhotoUrl;

  const PostView(
      {required this.username,
        required this.pid,
        required this.uid,
        required this.caption,
        required this.profilePhotoUrl,
        required this.location,
      });

  _PostView createState() => _PostView(
      username: this.username,
      caption: this.caption,
      uid: this.uid,
      profilePhotoUrl: this.profilePhotoUrl,
    location:this.location,
     );
}

class _PostView extends State<PostView> {
  final String username;
  final String caption;
  final String location;
  final String uid;
  final String profilePhotoUrl;
  String choosenSeat="-1";

  _PostView({required this.username, required this.caption, required this.uid, required this.profilePhotoUrl,required this.location});

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
  buildClickableBody({required String caption,required String location}) {
    return InkWell(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:<Widget>[
              Flexible(
                  flex:2,
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/sedan.png',
                        //width: MediaQuery.of(context).size.width,
                        height: 150,
                        width: 300,
                        fit: BoxFit.fitWidth,
                      ),
                      Text("Sedan, 4 Seat",
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w400,
                              fontSize: 20))
                    ],
                  )),
              Flexible(
                  flex:4,
                  child:
                  Column(
                      children:<Widget>[
                        Text(location,
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
                    Text("1 Available Seat",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.normal,
                            fontSize: 12)),
                    TextButton(onPressed: (){
                      //MAKE Reservation check choose
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
    buildPostHeader(username: this.username, profilePhotoUrl: this.profilePhotoUrl),
    buildClickableBody(caption: this.caption,location: this.location),
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
