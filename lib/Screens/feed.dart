import 'dart:convert';
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
    await getPosts();
    await getProfile();
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
                  onTap: () {
                  },
                  child: Icon(
                    Icons.search,
                    size: 26.0,
                  ),
                )
            ),
            Builder(
              builder: (context) =>Padding(
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
                  onTap: () {logOut();},
                  child: Icon(
                  Icons.logout,
                  size: 26.0,
                  ),
                  )
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {

        },),
        endDrawer: Drawer(
          child:ListView(
            children: <Widget>[
              Container(
                height:MediaQuery.of(context).size.height/3,
                child:Expanded(
                  child:UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  accountEmail: Expanded(
                            flex:1,
                            child: Text(AuthObject.userEmail),
                  ),
                  accountName: Expanded(
                    flex:1,
                    child: Text(AuthObject.userName),
                  ),
                  currentAccountPicture: new CircleAvatar(
                    radius: 120.0,
                    backgroundColor: const Color(0xFF778899),
                    backgroundImage:
                    NetworkImage("https://i20.haber7.net/resize/1300x731//haber/haber7/photos/2021/11/devrekliler_maci_mesut_ozilin_locasindan_izledi_1615873131_6892.jpg"),
                  ),
                  currentAccountPictureSize: Size(144,144),
                ),),
              ),
              ListTile(
                title: Text('Driver Rating'),
                trailing:Text('%98',style:TextStyle(color:Colors.green)),
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
            ]
        ),
      ),
        body:SingleChildScrollView(
          child:Flex(
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
    /*
      // get all post models in a alist from backend
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      postModelList = list.map((model) => PostModel.fromJson(model)).toList();
      _generateView(postModelList);
    } else {
      throw Exception('Failed to load posts');
    }
    */
     //for test purposes
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
    }
    _generateView(postModelList);
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
        username: postList[index].username ,
        pid: postList[index].pid ,
        uid: postList[index].uid ,
        caption: postList[index].caption ,
        profilePhotoUrl: postList[index].profilePhotoUrl ,
        location:postList[index].location,
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

  }
}


