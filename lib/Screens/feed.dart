import 'dart:convert';
import 'package:car_pool/CustomViews/share_ride.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:car_pool/CustomViews/post_view.dart';
import 'package:car_pool/Models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:car_pool/Screens/profile.dart';

import 'login.dart';

import 'package:car_pool/main.dart';

class Feed extends StatefulWidget {
  @override
  _Feed createState() => _Feed();
}

class _Feed extends State<Feed>{
  List<PostView> postViewList = [];
  List<PostModel> postModelList = [];
  bool firstLoad = true;
  List<PostModel> testList = [];
  ScrollController _controller = ScrollController();


  @override
  void initState() {
    super.initState();
    initialFunction().whenComplete(() => setState(() {
      firstLoad = false;
    }));
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
      return SingleChildScrollView(
        controller: _controller,
        child:ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
        children: postViewList,
        ));
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
    if(firstLoad){
      return Card();
    }
    else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          automaticallyImplyLeading: false,
          title: Text(
            "Car Pool",
            style: TextStyle(
              color: Colors.black87,
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
        ),
        floatingActionButton: FloatingActionButton(
          child:Icon(Icons.add,),
          onPressed: () {
              shareDialog();
        },),
        endDrawer: Drawer(
          child: ListView(
              children: <Widget>[
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 3,
                  child: Expanded(
                    child: UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      accountEmail: Expanded(
                        flex: 1,
                        child: Column(children:<Widget>[
                          Text(AuthObject.userEmail),
                          //Text(AuthObject.phoneNumber),
                        ],
                      ),),
                      accountName: Expanded(
                        flex: 1,
                        child: Text(AuthObject.userName),
                      ),
                      currentAccountPicture: new CircleAvatar(
                        radius: 120.0,
                        backgroundColor: const Color(0xFF778899),
                        backgroundImage:
                        NetworkImage(
                            "https://i20.haber7.net/resize/1300x731//haber/haber7/photos/2021/11/devrekliler_maci_mesut_ozilin_locasindan_izledi_1615873131_6892.jpg"),
                      ),
                      currentAccountPictureSize: Size(144, 144),
                    ),),
                ),
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
              ]
          ),
        ),
        body: SingleChildScrollView(
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 2,
                child: Card(),
              ),
              Expanded(
                flex: 10,
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: Scrollbar(
                    controller: _controller,
                    isAlwaysShown: true,
                    showTrackOnHover: true,
                    child: buildFeed(),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Card(),
              ),
            ],
          ),
        ),
        /*body: Padding(
          padding: EdgeInsets.fromLTRB(100,0,100,0),
          child: RefreshIndicator(
              onRefresh: _refresh,
              child: buildFeed(),
            ),
          ),*/
      );
    }
  }
  void shareDialog() {
    showDialog(builder: (BuildContext context) {
      return Card(
          margin: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width/3,vertical:MediaQuery.of(context).size.height/8),
          child: ShareRide()
      );
    }, context: context);
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
    final Map<String, dynamic> responseData = json.decode(response.body);
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

  Future<void> _refresh() async {
    print("refresh");
    postModelList.clear();
    postViewList.clear();
    await getPosts();
  }
  _generateView (List<PostModel> postList){
    int index = 0;
    while (index < postList.length) {
      PostView temp = PostView(
        owner: postList[index].owner['first_name'],
        caption: postList[index].caption ,
        type: postList[index].type,
        profilePhotoUrl: postList[index].owner['profile_photo'] ,
        available_seats:postList[index].available_seats,
        departure_location:postList[index].departure_location,
        destination:postList[index].destination,
        ride_datetime:postList[index].ride_datetime,
        post_datetime:postList[index].post_datetime,
        is_full:postList[index].is_full,
        remaining_seats:postList[index].remaining_seats,
      );
      postViewList.add(temp);
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
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.account_circle),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your first-name';
                }
                return null;
              },
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
              obscureText: false,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.account_circle),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Last-name';
                }
                return null;
              },
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
              keyboardType: TextInputType.visiblePassword,
              obscureText: false,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.phone_rounded),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
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
                  if (_editKey.currentState!.validate()) {
                    _editKey.currentState!.save();
                    UpdateProfile(first_name,last_name,phoneNumber,context);
                  }
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

Future UpdateProfile(String name,String name2,String phoneNumber, BuildContext context) async {
  var updateData = {
    'first_name': name,
    'last_name': name2,
    'phone_number':phoneNumber,
  };
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
    AuthObject.csrf = responseData['token'];
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
