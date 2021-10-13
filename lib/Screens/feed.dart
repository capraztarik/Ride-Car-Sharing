import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:car_pool/CustomViews/post_view.dart';
import 'package:car_pool/Models/post_model.dart';
import 'package:flutter/material.dart';

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
    if (firstLoad) {
      return Scaffold(
          body: SafeArea(
            child: Center(
                child: Container(
                    height: 50, width: 50, child: CircularProgressIndicator())),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: Text(
            "Car Pool",
            style: TextStyle(
              color: Colors.black87,
            ),
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
    for(int i=0;i<8;i++){
      PostModel temp=PostModel(
          username: "Lewis Hamilton",
          pid: "0",
          uid: "0",
          caption: "Kadıköy-Sabancı",
          profilePhotoUrl: "https://upload.wikimedia.org/wikipedia/commons/1/18/Lewis_Hamilton_2016_Malaysia_2.jpg",

    );
      postModelList.add(temp);
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
      );
      postViewList.add(temp);
      index++;
    }
  }



}
