import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:promethean_2k19/carousel_slider.dart';
import 'package:promethean_2k19/common/helper.dart';
import 'package:promethean_2k19/screens/aboutUs.dart';
import 'package:promethean_2k19/screens/registeredEvents.dart';
import 'package:promethean_2k19/screens/registration_screen.dart';
import 'package:promethean_2k19/screens/seeAll_events.dart';
import 'package:promethean_2k19/screens/user_profile.dart';
import 'package:promethean_2k19/utils/bottomNav.dart';

import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  // final MainModel model;
  // HomeScreen({Key key, this.model}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Widget body = Container();
  int currentIndex = 0;
  DateTime currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Press again to exit App"),
      ));
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext buildContext) {
    print("in homeScreen");

    final _size = MediaQuery.of(buildContext).size;
    final List<Widget> chliderens = [
      HomeScreenBody(deviceSize: _size),
      RegisteredEvents(Helper.authenticatedUser.uid),
      Center(child: Text("Hello")),
      AboutCollege(
        deviceSize: _size,
      ),
    ];
    return Scaffold(
      key: scaffoldKey,
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: false,
        onItemSelected: (index) => setState(() {
          currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
              width: 130.0,
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: Colors.red,
              inactiveColor: Colors.black),
          BottomNavyBarItem(
              width: 170.0,
              icon: Icon(Icons.event_available),
              title: Text(
                'Registered Events',
                style: TextStyle(fontSize: 13.0),
              ),
              activeColor: Colors.red,
              inactiveColor: Colors.black),
          BottomNavyBarItem(
              width: 130.0,
              icon: Icon(Icons.people),
              title: Text('Alerts'),
              activeColor: Colors.red,
              inactiveColor: Colors.black),
          BottomNavyBarItem(
              width: 130.0,
              icon: Icon(Icons.error_outline),
              title: Text('About Us'),
              activeColor: Colors.red,
              inactiveColor: Colors.black),
        ],
      ),
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(buildContext).push(CupertinoPageRoute(
                  builder: (BuildContext context) => UserProfile()));
            },
            icon: Icon(Icons.person, color: Colors.black),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 3.0,
        title: new Text(
          "Promethean2k19",
          style: new TextStyle(
            color: Colors.black,
            fontFamily: 'bebas-neue',
            fontSize: 25.0,
          ),
        ),
      ),
      body: WillPopScope(onWillPop: onWillPop, child: chliderens[currentIndex]),
    );
  }
}

class HomeScreenBody extends StatefulWidget {
  final Size deviceSize;
  const HomeScreenBody({Key key, this.deviceSize}) : super(key: key);
  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  List<Widget> mainScreenwidgets = [];
  TextStyle labelStyle;
  List<String> l = [];
  List<String> technical = [];
  // List<String> galleryImages=[];
  List<Widget> galleryWidgets = [];
  var _futureNonTech;
  ScrollController scrollController = new ScrollController();

  Future<List<Widget>> galleryNetworkImages() async {
    await http
        .get("https://promethean2k19-68a29.firebaseio.com/gallery_images.json")
        .then((http.Response response) {
      Map<String, dynamic> map = json.decode(response.body);
      // print("json body gallery: $map");
      map.forEach((String uniqueId, dynamic value) {
        // print(value);
        // print(value);
        galleryWidgets.add(galleryNetworkCards(imageurl: value));
      });
    });
    return galleryWidgets;
  }

  Future<List<String>> fetchNonTecNetworkImages() async {
    List<String> temp = [];
    await http
        .get(
            "https://promethean2k19-68a29.firebaseio.com/main_screen/Non_technical_events.json")
        .then((http.Response response) {
      Map<String, dynamic> map = json.decode(response.body);
      // print("json body non tech: $map");
      map.forEach((String uniqueId, dynamic value) {
        // print(value);
        // print(value["imageurl"]);
        temp.add(value["imageurl"]);
      });
    });
    return temp;
  }

  Future<List<String>> fetchTechNetworkImages() async {
    List<String> temp = [];
    await http
        .get(
            "https://promethean2k19-68a29.firebaseio.com/main_screen/technical_events.json")
        .then((http.Response response) {
      Map<String, dynamic> map = json.decode(response.body);
      // print("json body technical_events: $map");
      map.forEach((String uniqueId, dynamic value) {
        // print(value);
        print(value["imageurl"]);
        temp.add(value["imageurl"]);
      });
      print("list: $technical");
    });
    return temp;
  }

  callSetState() {
    setState(() {});
  }

  @override
  void initState() {
    galleryWidgets.add(galleryCards(imageurl: "assets/steak_on_cooktop.jpg"));
    galleryWidgets.add(galleryCards(imageurl: "assets/steak_on_cooktop.jpg"));
    galleryWidgets.add(galleryCards(imageurl: "assets/steak_on_cooktop.jpg"));

    labelStyle = new TextStyle(
      fontSize: widget.deviceSize.width * 0.049,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );

    mainScreenwidgets.add(slider());
    mainScreenwidgets.add(_getHeader(
        widget.deviceSize.width, "Central Events", labelStyle, false, () {}));
    mainScreenwidgets.add(_getFeaturedEvents(widget.deviceSize.width));
    mainScreenwidgets.add(_getHeader(
        widget.deviceSize.width, "Departments", labelStyle, false, () {}));
    // mainScreenwidgets.add(_getDeptList());
    super.initState();
  }

  Widget _getDeptList() {
    int index = 0;
    return Column(
        children: [
      ["CSE", "IT", "ECE"],
      ["CIV", "MECH", "EEE"],
      ["PHE", "BME", "CHEM"],
    ].map((outerValue) {
      print("index is $index");
      return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            outerValue[0],
            outerValue[1],
            outerValue[2],
          ].map((innerIndex) {
            return getDepartments(innerIndex);
          }).toList());
    }).toList());
  }

  Widget getDepartments(String title) {
    print(title);
    return Container(
      margin: EdgeInsets.all(2.0),
      child: Card(
        child: Container(
          child: Center(
            child: Text(title),
          ),
          width: 50.0,
          height: 50.0,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _getHeader(double width, String label, TextStyle labelStyle,
      bool seeall, Function onpressed) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
          child: Row(
            children: <Widget>[
              Text(label, style: labelStyle),
              Expanded(
                child: Container(),
              ),
              seeall
                  ? Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: CupertinoButton(
                        minSize: 20.0,
                        onPressed: onpressed,
                        // color: Colors.tran,
                        child: Text(
                          "See all",
                          style: labelStyle.copyWith(
                              color: Colors.lightBlue, fontSize: width * 0.038),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  slider() {
    return FutureBuilder<List<Widget>>(
      future: galleryNetworkImages(),
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return CarouselSlider(
                autoPlayCurve: Curves.easeInOutCubic,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                aspectRatio: widget.deviceSize.aspectRatio * 3.5,
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(seconds: 2),
                items: galleryWidgets);
          case ConnectionState.done:
            if (snapshot.hasError) {
              return CarouselSlider(
                  autoPlayCurve: Curves.easeInOutCubic,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  aspectRatio: widget.deviceSize.aspectRatio * 3.5,
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  autoPlayAnimationDuration: const Duration(seconds: 2),
                  items: galleryWidgets);
            }
            return CarouselSlider(
                autoPlayCurve: Curves.easeInOutCubic,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                aspectRatio: widget.deviceSize.aspectRatio * 3.5,
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(seconds: 2),
                items: galleryWidgets);
        }
        return Container();
      },
    );
  }

  galleryNetworkCards({@required String imageurl}) {
    return Container(
      padding: EdgeInsets.only(top: 13.0, right: 2.0, left: 2.0, bottom: 5.0),
      height: 100.0,
      width: double.infinity,
      decoration: BoxDecoration(
        // color: Colors.red,
        borderRadius: new BorderRadius.circular(20.0),
      ),
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(20.0),
        child: Card(elevation: 5.0, child: networkCard(imageurl: imageurl)),
      ),
    );
  }

  Widget galleryCards({@required String imageurl}) {
    return Container(
      padding: EdgeInsets.only(top: 13.0, right: 2.0, left: 2.0, bottom: 5.0),
      height: 100.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(20.0),
      ),
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(20.0),
        child: Card(
          color: Colors.transparent,
          elevation: 5.0,
          child: Image.asset(
            imageurl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        itemCount: mainScreenwidgets.length + 9,
        itemBuilder: (BuildContext context, int index) {
          if (index >= mainScreenwidgets.length) {
            List<String> tempList = [
              "Biomedical Engineering",
              "Chemical Engineering",
              "Civil Engineering",
              "Computer Science and Engineering",
              "Electrical and Electronic Engineering",
              "Electronics and Communication Engineering",
              "Information Technology",
              "Mechanical Engineering",
              "Pharmaceutical Engineering",
            ];
            print(tempList[index - mainScreenwidgets.length].length);
            return buildBranchCard(tempList, index);
          }
          return mainScreenwidgets[index];
        });
  }

  String getBranchShort(String branch)
  {
    if(branch.toLowerCase()=="biomedical engineering")
    {
      return "BME";
    }
    else if(branch.toLowerCase()=="chemical engineering"){
      return "CHEM";
    }
    else if(branch.toLowerCase()=="civil engineering")
    {
      return "CIVIL";
    }
    else if(branch.toLowerCase()=="computer science and engineering")
    {
      return "CSE";
    }
    else if(branch.toLowerCase()=="electrical and electronic engineering")
    {
      return "EEE";
    }
    else if(branch.toLowerCase()=="electronics and communication engineering")
    {
      return "ECE";
    }
    else if(branch.toLowerCase()=="information technology"){
        return "IT";
    }
    else if(branch.toLowerCase()=="mechanical engineering")
    {
      return "MECH";
    }
    else if(branch.toLowerCase()=="pharmaceutical engineering")
    {
      return "PHE";
    }
    return "NOT THERE";
  }


  Widget buildBranchCard(List<String> tempList, int index) {
    TextStyle textStyle = TextStyle(fontFamily: 'QuickSand',fontSize: 22%widget.deviceSize.width*0.65, color: Colors.white);
    // TextStyle textStyle = const TextStyle(fontFamily: 'QuickSand',fontSize: 20.0,color: Colors.white);
    return Padding(
      padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
      child: InkWell(
          onTap: (){
            print(tempList[index-mainScreenwidgets.length]);
           String temp= getBranchShort(tempList[index-mainScreenwidgets.length]);
           print(temp);
           Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) {
                return AllEventScreen(deptName: temp,);
           }));
          },
              child: Card(
          color: Colors.transparent,
          elevation: 5.0,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/steak_on_cooktop.jpg')),
                    color: Colors.blue.withOpacity(0.2),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.transparent,
                          Colors.black.withOpacity(0.9),
                        ])),

                height: widget.deviceSize.height * 0.3,

                // margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 2.0),
              ),
              Positioned(
                bottom: 10.0,
                left: 20.0,
                child: Text(tempList[index - mainScreenwidgets.length],style: textStyle,)),
            ],
          ),
        ),
      ),
    );
  }

  Widget networkCard({String imageurl}) {
    print("printed tech : in netwrok $technical");
    return CachedNetworkImage(
        imageUrl: imageurl,
        imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        placeholder: (context, url) => Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            ),
        errorWidget: (context, url, error) {
          print("error in network card $error\n with url $url");
          return Container(child: Center(child: CircularProgressIndicator()));
        });
  }

  List<String> eventList = [
    "Poster Presentation",
    "Project Expo",
    "Paper Presentation",
    "Workshop",
  ];

  Widget _getFeaturedEvents(double width) {
    int index = 0;
    return Column(
        children: List<String>(2).map<Widget>((_) {
      print("index is $index");
      print("index is $index");
      return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List(2).map((T) {
            return _buildCustomeCard(
                width, 'assets/steak_on_cooktop.jpg', eventList[index++]);
          }).toList());
    }).toList());
  }

  Widget _buildCustomeCard(double width, String imageAsset, String title) {
    return Tooltip(
      message: title,
      child: InkWell(
        onTap: () {
          print("taped featured_events/$title");
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: MultiSelectChip(
                    reportList: <String>[
                      "CSE",
                      "IT",
                      "ECE",
                      "EEE",
                      "BME",
                      "PHE",
                      "CIVIL",
                      "CHEM",
                      "MECH"
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel"),
                    ),
                    FlatButton(
                      onPressed: () {
                        String dep = _MultiSelectChipState.getChoice();
                        print(dep.length);
                        if (dep.length != 0) {
                          Navigator.of(context).pushReplacement(CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  RegistrationScreen(
                                    organizingDepartment: dep,
                                    eventName: title.trim(),
                                  )));
                        }
                      },
                      child: Text("Continue"),
                    ),
                  ],
                );
              });
          print(title.trim());
        },
        child: Card(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Card(
                  elevation: 0.0,
                  child: Container(
                    width: width * 0.4,
                    height: width * 0.4,
                    // color: Colors.red,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(imageAsset), fit: BoxFit.cover),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.2),
                            ])),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
              Positioned(
                bottom: -5.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Card(
                    elevation: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      width: width * 0.47,
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(title,
                              softWrap: false,
                              style: labelStyle.copyWith(
                                fontSize: width * 0.04,
                                fontFamily: 'bebas-neue',
                                letterSpacing: 1.5,
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  MultiSelectChip({this.reportList});
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  static String getChoice() {
    return _MultiSelectChipState.selectedChoice;
  }

  static String selectedChoice = "";
  // this function will build and return the choice list
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
