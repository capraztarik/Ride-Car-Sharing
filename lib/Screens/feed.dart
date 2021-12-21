import 'dart:convert';
import 'package:car_pool/CustomViews/share_ride.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:car_pool/CustomViews/post_view.dart';
import 'package:car_pool/Models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:car_pool/Screens/profile.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

import 'login.dart';

import 'package:car_pool/main.dart';

class Feed extends StatefulWidget {
  @override
  _Feed createState() => _Feed();
}

class _Feed extends State<Feed>{
  late SearchBar searchBar;
  List<PostView> postViewList = [];
  List<PostModel> postModelList = [];
  List<dynamic> prevRideJson=[];
  bool firstLoad = true;
  bool refresh =false;
  List<PostModel> testList = [];
  ScrollController _controller = ScrollController();


  @override
  void initState() {
    super.initState();
    initialFunction().whenComplete(() => setState(() {
      firstLoad = false;
    }));
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: onSubmitted,
        buildDefaultAppBar: buildAppBar
    );
  }
  Future onSubmitted(String value) async {
    var tkn=AuthObject.csrf;

    final response = await http.get(
      Uri.parse('http://ride-share-cs308.herokuapp.com/api/posts/?destination='+value),
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization":"Token $tkn",
      },
    );

    if(response.statusCode==200){

      print("Successfully search");
      final List<dynamic> responseData = json.decode(response.body);
      print(responseData);

      postModelList.clear();
      postViewList.clear();
      setState(() {
        refresh = true;
      });
      Iterable list = json.decode(response.body);
      postModelList = list.map((model) => PostModel.fromJson(model)).toList();

      await _generateView(postModelList);
      await getProfile();

      setState(() {
        refresh = false;
      });
    }
    else {
      print(response.statusCode);
      print(response.body);
    }

  }
  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      backgroundColor: Colors.blue,
      automaticallyImplyLeading: false,
      title: Text(
        "RIDE",
        style: TextStyle(
          fontSize: 30.0,
          letterSpacing:3,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: () {
                _refresh();
              },
              child: Icon(
                Icons.refresh,
                size: 26.0,
              ),
            )
        ),
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: searchBar.getSearchAction(context)
          /*InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.search,
                    size: 26.0,
                  ),
                )*/
        ),
        Builder(
          builder: (context) =>
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: InkWell(
                    onTap: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    child: Icon(
                      Icons.account_circle_sharp,
                      size: 26.0,
                    ),
                  )
              ),
        ),
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: () {
                logOut();
              },
              child: Icon(
                Icons.logout,
                size: 26.0,
              ),
            )
        ),
      ],
    );
  }

  Future<void> initialFunction() async {
    await getProfile();
    await getPosts();
  }

  dispose() {
    super.dispose();
  }
  buildFeed() {
    /*This creates feed from list of PostCards*/
    if (postViewList != null && postViewList.length != 0) {
      return ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
        children: postViewList,
        );
    } else if (postViewList.length == 0) {
      return Center(
        child: Text(
          "No posts to show.",
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      );
    } else {
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    if(firstLoad || refresh){
      return Card();
    }
    else {
      return Scaffold(
        appBar: searchBar.build(context),
        floatingActionButton: FloatingActionButton(
          child:Icon(Icons.add,),
          onPressed: () {
              shareDialog() ;
        },),
        endDrawer: Drawer(
          child: ListView(
              children: <Widget>[
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 3,
                  child:  UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      accountEmail: Column(children:<Widget>[
                          Text(AuthObject.userEmail),
                          //Text(AuthObject.phoneNumber),
                        ],
                      ),
                      accountName: Text(AuthObject.userName),
                      currentAccountPicture: new CircleAvatar(
                        radius: 120.0,
                        backgroundColor: const Color(0xFF778899),
                        backgroundImage:
                        NetworkImage(
                            photoUrl),
                      ),
                      currentAccountPictureSize: Size(144, 144),
                    ),),
                ListTile(
                  title: Text('Driver Rating'),
                  trailing: Text('%98', style: TextStyle(color: Colors.green)),
                  // You can write the navigation code in this block of function,
                  // So you can navigate to the other page.
                ),
                ListTile(
                  title: Text('Edit Profile'),
                  onTap: () {
                    editProfile();
                  },
                  // To make the list tile clickable I added empty function block
                ),
                ListTile(
                  title: Text('Update Password'),
                  onTap: () {
                    editPass();
                  },
                  // To make the list tile clickable I added empty function block
                ),
                ListTile(
                  title: Text('Joined Rides',
                  style:TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 26
                  )),
                ),
                ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                children: previusRidesViewList(prevRideJson),
                   ),

              ]
          ),
        ),
        /*body: RefreshIndicator(
          onRefresh: _refresh,
          child:Flex(
              direction: Axis.horizontal,
              children: [
              Expanded(
                flex: 2,
                child: Card(),
              ),
              Expanded(
                flex: 10,
                  child: buildFeed(),
                  ),
              Expanded(
                flex: 2,
                child: Card(),
              ),
            ],
          ),
        ),*/
        body: Padding(
          padding: EdgeInsets.fromLTRB(100,0,100,0),
          child: RefreshIndicator(
              onRefresh: _refresh,
              child: buildFeed(),
            ),
          ),
      );
    }
  }
  void shareDialog() async {
    showDialog(builder: (BuildContext context) {
      return Card(
          margin: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width/3,vertical:MediaQuery.of(context).size.height/8),
          child: ShareRide()
      );
    }, context: context).then((val){_refresh();});
  }
  Future<void> getProfile() async{
    var tkn=AuthObject.csrf;
    final response = await http.get(
      Uri.parse('http://ride-share-cs308.herokuapp.com/api/users/my-profile/'),
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization":"Token $tkn",
      },
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    if(response.statusCode==200){
      AuthObject.userName=responseData['first_name'] + " " +responseData['last_name'];
      AuthObject.phoneNumber=responseData['phone_number'];
      photoUrl=responseData['profile_photo'];
      prevRideJson=responseData['previous_rides'];
    }
    else {
      print(response.statusCode);
    }
  }
  Future<void> getPosts() async {
    var tkn=AuthObject.csrf;
    final response = await http.get(
      Uri.parse('http://ride-share-cs308.herokuapp.com/api/posts/'),
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization":"Token $tkn",
      },
    );
    final List<dynamic> responseData = json.decode(response.body);
    print(responseData);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      postModelList = list.map((model) => PostModel.fromJson(model)).toList();

      _generateView(postModelList);
    }
    else {
      print(response.statusCode);
    }
     /*for test purposes
    for(int i=0;i<4;i++){
      PostModel temp=PostModel(
          username: "Lewis Hamilton",
          pid: "0",
          uid: "0",
          location: "Kadıköy-Sabancı",
          caption:"Maltepe üzerinden Sabancıya geçiceğim.",
          profilePhotoUrl: "https://upload.wikimedia.org/wikipedia/commons/1/18/Lewis_Hamilton_2016_Malaysia_2.jpg",

    );
      PostModel temp2=PostModel(
        username: "Charles Leclerc",
        pid: "0",
        uid: "0",
        caption:"Ataşehire eşyalarımı bırakıcağım.",
          location: "Pendik-Ataşehir",
        profilePhotoUrl: "https://cdn-9.motorsport.com/images/mgl/YBeNJN72/s800/charles-leclerc-ferrari-1.jpg",

      );
      postModelList.add(temp);
      postModelList.add(temp2);
    }*/
  }
  Future<void> getPreviousRides() async {
    var tkn=AuthObject.csrf;
    final response = await http.get(
      Uri.parse('http://ride-share-cs308.herokuapp.com/api/posts/'),
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization":"Token $tkn",
      },
    );
    final List<dynamic> responseData = json.decode(response.body);
    print(responseData);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      postModelList = list.map((model) => PostModel.fromJson(model)).toList(); //TODO Create prev ride Model and fromJson method

      _generateView(postModelList);
    }
    else {
      print(response.statusCode);
    }

  }
  Future<void> _refresh() async {
    print("refresh");
    postModelList.clear();
    postViewList.clear();
    setState(() {
      refresh = true;
    });
    await getPosts();
    await getProfile();
    setState(() {
      refresh = false;
    });
  }

  _generateView (List<PostModel> postList){
    var purl;
    int index = 0;
    while (index < postList.length) {

      if(postList[index].owner['profile_photo'] !=null){
        purl= postList[index].owner['profile_photo'];
    }
    else{
        purl = "https://cdn.sporx.com/img/59/2021/image23-1630500411.jpg";
    }

    PostView temp = PostView(
        id:postList[index].id,
        owner: postList[index].owner['first_name'],
        caption: postList[index].caption ,
        type: postList[index].type,
        profilePhotoUrl: purl ,
        available_seats:postList[index].available_seats,
        departure_location:postList[index].departure_location,
        destination:postList[index].destination,
        ride_datetime:postList[index].ride_datetime,
        post_datetime:postList[index].post_datetime,
        is_full:postList[index].is_full,
        remaining_seats:postList[index].remaining_seats,
      );
      setState(() {
        postViewList.add(temp);
      });

      index++;
    }



















  }

  Future logOut() async {
    var result;
    var tkn=AuthObject.csrf;
    final response = await http.post(
      Uri.parse('http://ride-share-cs308.herokuapp.com/api/users/logout/'),
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
          "Authorization":"Token $tkn",
      },
    );

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

  Future editProfile()async {
    showDialog(builder: (BuildContext context) {
      return Card(
          margin: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width/3.5,vertical:MediaQuery.of(context).size.height/6),
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 30,vertical:15),
            child:EditProfileDialog(),
          )
      );
    }, context: context);
  }
  Future editPass()async {
    showDialog(builder: (BuildContext context) {
      return Card(
          margin: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width/3.5,vertical:MediaQuery.of(context).size.height/6),
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 30,vertical:15),
            child:ChangePasswordDialog(),
          )
      );
    }, context: context);
  }
}
GlobalKey<FormState> _editKey = GlobalKey<FormState>();
String first_name="";
String last_name="";
String phoneNumber="";
String profile_photo="";
String currentpass="";
String newpass="";
String newpass2="";
String photoUrl="";

class EditProfileDialog extends StatefulWidget{

  _EditProfileDialog createState() => _EditProfileDialog();
}
class _EditProfileDialog extends State<EditProfileDialog> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key:_editKey,
      child:Column(
        children: <Widget>[
          Expanded(flex:2,
            child:TextFormField(
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: 'Your Profile Picture URL',
                hintText:photoUrl ,
                helperText:photoUrl,
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.photo),
              ),
              onSaved: (value) {
                photoUrl = value!;
              },
            ),),
          Expanded(flex:1,
            child:SizedBox(
              height: sized_box_height,
            ),),
          Expanded(flex:2,
            child:TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'First Name',
                helperText:first_name ,
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.account_circle),
              ),
              onSaved: (value) {
                first_name = value!;
              },
            ),),
          Expanded(flex:1,
            child:SizedBox(
              height: sized_box_height,
            ),),
          Expanded(flex:2,
            child:TextFormField(
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: 'Last Name',
                helperText:last_name ,
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.account_circle),
              ),
              onSaved: (value) {
                last_name = value!;
              },
            ),),
          Expanded(flex:1,
            child:SizedBox(
              height: sized_box_height,
            ),),
          Expanded(flex:2,
            child:TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                helperText:phoneNumber ,
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.phone_rounded),
              ),
              onSaved: (value) {
                phoneNumber = value!;
              },
            ),),
          Expanded(flex:1,
            child:SizedBox(
              height: sized_box_height,
            ),),
          Expanded(flex:2,
            child:Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: MaterialButton(
                onPressed: () {
                  _editKey.currentState!.save();
                  UpdateProfile(first_name,last_name,phoneNumber,photoUrl,context);
                },
                color: Colors.blue,
                child: Text(
                  'Update Profile',
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
        ],
      ),
    );
  }

}

Future UpdateProfile(String name,String name2,String phoneNumber,String photoUrl, BuildContext context) async {
  var updateData = {};
  if(name!=""){
    updateData['first_name']= name;
  }
  if(name2!=""){
    updateData['last_name']= name2;
  }
  if(phoneNumber!=""){
    updateData['phone_number']= phoneNumber;
  }
  if(photoUrl!=""){
    updateData['profile_photo']= photoUrl;
  }

  var tkn=AuthObject.csrf;
  final response = await http.patch(
    Uri.parse('http://ride-share-cs308.herokuapp.com/api/users/my-profile/'),
    headers:{
      'Content-Type': 'application/json; charset=UTF-8',
      "Access-Control-Allow-Origin": "*",
      "Authorization":"Token $tkn",
    },
    body: jsonEncode(updateData),
  );

  final Map<String, dynamic> responseData = json.decode(response.body);
  if(response.statusCode==200){
    print("Successfully changed");
   // AuthObject.csrf = responseData['token'];
    print(AuthObject.csrf);
    AuthObject.userEmail=email;
    print(AuthObject.userEmail);
    /*User authUser = User.fromJson(userData);*/
    /*UserPreferences().saveUser(authUser);*/
    Navigator.pop(context);
  }
  else {
    print(response.statusCode);
    print(response.body);
  }


}

List<Column>  previusRidesViewList(List<dynamic> preRideList){
  List<Column> temp=[];
  int index=0;

  while (index < preRideList.length) {
    DateTime rideDate =DateTime.parse(preRideList[index]['ride_datetime']);

    Column cl=Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:<Widget>[
          Text(rideDate.toString().substring(0,16),
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w400,
                fontSize: 20
            ),),
          Text(preRideList[index]['departure_location']+"-"+preRideList[index]['destination'],
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w400,
                fontSize: 20
            ),),
          Divider(
            height: 10,
            thickness: 2,
            indent: 20,
            endIndent: 0,
            color: Colors.blue,
          ),
        ]
    );
    temp.add(cl);
    index++;
  }
  return temp;
}
class ChangePasswordDialog extends StatefulWidget{

  _ChangePasswordDialog createState() => _ChangePasswordDialog();
}
class _ChangePasswordDialog extends State<ChangePasswordDialog>{
  @override
  Widget build(BuildContext context) {
    return Form(
      key:_editKey,
      child:Column(
        children: <Widget>[
          Expanded(flex:2,
            child:TextFormField(
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.lock),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your current password';
                }
                return null;
              },
              onSaved: (value) {
                currentpass = value!;
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
                labelText: 'New password',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.lock),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your new password';
                }
                return null;
              },
              onSaved: (value) {
                newpass = value!;
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
                labelText: 'New Password again',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.lock),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your new password again';
                }
                else
                  {return null;}
              },
              onSaved: (value) {
                newpass2 = value!;
              },
            ),),
          Expanded(flex:1,
            child:SizedBox(
              height: sized_box_height,
            ),),
          Expanded(flex:2,
            child:Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: MaterialButton(
                onPressed: () {
                  if (_editKey.currentState!.validate()) {
                    _editKey.currentState!.save();
                    ChangePassword(currentpass,newpass,newpass2,context);
                  }
                },
                color: Colors.blue,
                child: Text(
                  'Change password',
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
        ],
      ),
    );
  }
}
Future ChangePassword(String curpass,String newpass,String newpass2,BuildContext context) async {

  if(newpass2!=newpass)
  {Fluttertoast.showToast(
      msg:  'Passwords do not match',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blue,
      textColor: Colors.white
  );  }
  else {
    var updateData = {
      'current_password': curpass,
      'new_password': newpass,
    };
    var tkn = AuthObject.csrf;
    final response = await http.patch(
      Uri.parse(
          'http://ride-share-cs308.herokuapp.com/api/users/set-new-password/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Token $tkn",
      },
      body: jsonEncode(updateData),
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      print("Successfully changed");
      Navigator.pop(context);
    }
    else {
      print(response.statusCode);
      print(response.body);
    }
  }
}
