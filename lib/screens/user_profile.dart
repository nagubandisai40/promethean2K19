import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:promethean_2k19/data_models/userinfo.dart';
import 'package:promethean_2k19/screens/userprofileUI.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Map<String, dynamic> _profileData;
  UserInfo userInfo;
  Future _future;

  Future<Null> _fetchProfile() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String uid = _prefs.get('uid');
    await http
        .get("https://promethean2k19-68a29.firebaseio.com/users/$uid/userInfo.json")
        .then((http.Response response) {
      Map<String, dynamic> fetchedData;
      fetchedData = json.decode(response.body);
      fetchedData.forEach((postId, innerMap) {
        userInfo = new UserInfo(
            uid: uid,
            userName: innerMap['userName'],
            email: innerMap['email'],
            phone: innerMap['phone'],
            college: innerMap['college'],
            year: innerMap['year'],
            rollNo: innerMap['rollNo'],
            branch: innerMap['branch']);
      });
      print("${userInfo.email}");

      if (response.statusCode == 200) {
        _profileData = json.decode(response.body);
        print("$_profileData[]");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _future = _fetchProfile();
  }

  final TextStyle lableStyle = new TextStyle(
      fontSize: 20.0,
      letterSpacing: 0.5,
      color: Colors.black,
      fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    // final Size _size = MediaQuery.of(context).size;

    return Scaffold(
        body: FutureBuilder<dynamic>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: (){},
                  color: Colors.black,
                  icon: Icon(Icons.arrow_back,color: Colors.black,),
                ),
                title: Text("User Profile",style: TextStyle(color: Colors.black,fontFamily: "bebas-neue"),),
                backgroundColor: Colors.white,
              ),
              body: Center(
                child: Container(
                  color: Colors.grey.withOpacity(0.5),
                  child: CupertinoAlertDialog(
                    content: SizedBox(
                      height: 45.0,
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            CircularProgressIndicator(
                              strokeWidth: 1.5,
                            ),
                            Expanded(
                              child: Text(
                                "Loading..",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            break;
          case ConnectionState.done:
            if (snapshot.hasError) {
              print("${snapshot.error}");
              return Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                  onPressed: (){},
                  color: Colors.black,
                  icon: Icon(Icons.arrow_back,color: Colors.black,),
                ),
                      title: Text("User Profile",style: TextStyle(fontFamily: "bebas-neue",color: Colors.black),),
                    backgroundColor: Colors.white,),
                    body: Center(
                    child: Text('Please check device network connnection')),
              );
            }
            print("${snapshot.hasData}");
            print("${snapshot.data}");
            return UserProfileUI(
              userInfo: userInfo,
            );
        }
        return null;
      },
    ));
  }
}
