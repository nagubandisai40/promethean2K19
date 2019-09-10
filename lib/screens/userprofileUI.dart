import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promethean_2k19/data_models/userinfo.dart';
import 'package:promethean_2k19/screens/authScreen.dart';
import 'package:promethean_2k19/utils/aboutapp.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../main.dart';

class UserProfileUI extends StatefulWidget {
  final UserInfo userInfo;

  const UserProfileUI({Key key, this.userInfo}) : super(key: key);
  @override
  _UserProfileUIState createState() => _UserProfileUIState();
}

class _UserProfileUIState extends State<UserProfileUI> {
  ScrollController controller;
  static BuildContext _context;

  static logout() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool t = await _prefs.clear();
    print(t);
    Navigator.of(_context).pop();
    Navigator.of(_context).pop();

    Navigator.of(_context).pushReplacement(CupertinoPageRoute(
        builder: (BuildContext context) => AuthScreen()));
  }

  static confirmDialog() {
    showDialog(
      context: _context,
    builder: (BuildContext context){
      return  CupertinoAlertDialog(
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            logout();
          },
          child: Text("Ok",style: TextStyle(color: Colors.red),),
        ),
        FlatButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Text("Cancel",style: TextStyle(color: Colors.blue),),
        ),
      ],
      content: Container(
          decoration: BoxDecoration(
            // color: Colors.white,
          ),
          child: Text("Do you Really want to Logout ?"),
        ),
     );
    }
    );
  }
  
  static showReportDeveloper(){
    AlertDialog(
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            logout();
          },
          child: Text("Send"),
        ),
        FlatButton(
          onPressed: (){
            Navigator.of(_context).pop();
          },
          child: Text("Cancel"),
        ),
      ],
      content: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Text("Press Ok to Logout?"),
        ),
     );
  }
  List<String> title = [];

  List<Widget> iconElement = [
    Icon(
      Icons.phone,
      size: 20.0,
      color: Colors.blueAccent,
    ),
    Icon(
      Icons.mail_outline,
      size: 20.0,
      color: Colors.redAccent,
    ),
    ImageIcon(
      AssetImage('assets/college.png'),
      size: 20.0,
      color: Colors.brown[300],
    ),
    ImageIcon(
      AssetImage('assets/branch.png'),
      size: 20.0,
      color: Colors.orange[300],
    ),
  ];
  List<String> functionTitles = [
    "Registered Events",
    "Report Developer",
    "About App",
    "Will You Rate Us ?",
    "Log out"
  ];

  List<Function> onpresseFunctions = [
    () {
      /// Naviagate to Registered Events
      print("Navigating to Registered Events");
    },
    () {
      ///for reporting developers as review
      print("Reporting to developer");
    },
    () {
      ///for About App Dialog
      showGalleryAboutDialog(_context);
      print("about APP");
    },
    () {
      /// for user to rate the app
      print("Rate the App");
    },
    () {
      // for log out
      print("clearing all");
      confirmDialog();
    }
  ];
  List<String> buttonIcons = [
    'assets/registeredEvents.png',
    'assets/bugs.png',
    'assets/aboutApp.png',
    'assets/rating.png',
    'assets/logOut.png',
  ];
  // List<Color> buttonIconColors =[
  Color toogleColor = Colors.white;
  // ];

  TextStyle lableStyle = const TextStyle(
    color: Colors.white,
    fontFamily: 'QuickSand',
    fontSize: 50.0,
    fontWeight: FontWeight.bold,
  );
  double textScale = 1;

  @override
  void initState() {
    title.add(widget.userInfo.phone);
    title.add(widget.userInfo.email);
    title.add(widget.userInfo.college);
    title.add(widget.userInfo.branch);
    controller = new ScrollController();
    controller.addListener(onScroll);
    super.initState();
  }

  void onScroll() {
    // print("controller offset $controller.offset");

    if (controller.offset < 1) {
      textScale = 1;
      // print("moving g");
    } else {
      textScale = 1 - controller.offset * 0.006;
      textScale = textScale.clamp(0.0, 1.0);
      // print("textScale: $textScale");
      // print("moving S");
    }
    setState(() {
      if (textScale < 0.3) {
        toogleColor = Colors.blueGrey;
      } else
        toogleColor = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 135.0),
                    child: Transform(
                      transform:
                          Matrix4.translationValues(0.0, -textScale * 5, 0.0),
                      child: Transform.scale(
                        scale: textScale,
                        child: Text(
                           "User Profile",
                          style: lableStyle.copyWith(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.08),
                        ),
                      ),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                    Color(0xFFf9c1c4),
                    Color(0xFFffc892),
                  ]),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            controller: controller,
            physics: ClampingScrollPhysics(),
            child: Container(
              // height: 200.0,
              margin: EdgeInsets.symmetric(horizontal: 6),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 135.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Container(
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 1.0,
                                      spreadRadius: 0.0,
                                    )
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40.0),
                                      topRight: Radius.circular(40.0))),
                              width: double.infinity,
                              // height: 100.0,
                              child: Padding(
                                  padding: const EdgeInsets.only(bottom: 50.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 120.0,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
                                        child: Text(
                                          widget.userInfo.userName,
                                          style: lableStyle.copyWith(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06,
                                            color: Colors.deepOrangeAccent[200],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Divider(
                                          height: 5.0,
                                          color: Colors.blueGrey[100],
                                        ),
                                      ),
                                      Column(
                                        children: [0, 1, 2, 3]
                                            .map((index) => buildDetails(index))
                                            .toList(),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Divider(
                                            height: 5.0,
                                            color: Colors.blueGrey[100],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Column(
                                          children: [0, 1, 2, 3, 4]
                                              .map((index) =>
                                                  buildButtons(index))
                                              .toList(),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          buildCircularProfilePic(context),
                        ],
                      ),
                      // color: Colors.cyan,
                    ),
                  ),
                ],
              ),
              // color: Colors.pinkAccent[200],
            ),
          ),
          Positioned(
            top: 25.0,
            left: 6.0,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: toogleColor, size: 25.0),
              onPressed: () {
                print("back");
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            top: 25.0,
            right: 6.0,
            child: IconButton(
              icon: Icon(
                Icons.settings,
                color: toogleColor,
                size: 25.0,
              ),
              onPressed: () {
                print("setting");
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildButtons(int index) {
    return Container(
      margin: EdgeInsets.only(left: 15.0),
      child: MaterialButton(
        onPressed: onpresseFunctions[index],
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: 25.0,
                      maxWidth: 30.0,
                      minHeight: 20.0,
                      minWidth: 20.0),
                  child: Image.asset(
                    buttonIcons[index],
                    fit: BoxFit.scaleDown,
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(functionTitles[index],
                    style: lableStyle.copyWith(
                        fontSize: 17.0, color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetails(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, top: 10.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(child: iconElement[index]),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(title[index],
                  style:
                      lableStyle.copyWith(fontSize: 17.0, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCircularProfilePic(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 1.0, spreadRadius: 1.0)
        ],
      ),
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width * 0.35),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.35,
          height: MediaQuery.of(context).size.width * 0.35,
          decoration:
              ShapeDecoration(shape: CircleBorder(), color: Colors.white),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0177),
            child: DecoratedBox(
              child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.35),
                  child: Image.asset(
                    "assets/pic.jpg",
                    fit: BoxFit.contain,
                  )),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: CircleBorder(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
