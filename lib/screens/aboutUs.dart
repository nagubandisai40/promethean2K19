import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promethean_2k19/utils/folder/data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:vhelp/utils.dart';

var style = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0);

class AboutCollege extends StatefulWidget {
  final Size deviceSize;

  const AboutCollege({Key key, this.deviceSize}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AboutCollegeState();
  }
}

class _AboutCollegeState extends State<AboutCollege> with TickerProviderStateMixin {
  AnimationController fabcontroller;
  AnimationController floatingAboutButtonController;
  Widget activeWidget;

  @override
  void initState() {
    fabcontroller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    setActivePage();
    fabcontroller.forward();
    floatingAboutButtonController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  setActivePage() {
    setState(() {
      activeWidget = getCollegePage();
    });
  }

  startFloatingForward() {
    print("startFloatingForward");
    setState(() {
      floatingAboutButtonController.reset();
      floatingAboutButtonController.forward();
    });
  }

  showDialogButton() {
    startFloatingForward();
    showDialog(
        barrierDismissible: true,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0),
                width: double.infinity,
                // height: MediaQuery.of(context).size.height * 0.5,
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              buildFloatingTransparentButton(
                                  backgroundColor: Colors.transparent,
                                  onPressed: () {
                                    setState(() {
                                      activeWidget = getDeveloperPage();
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  title: "About Developers",
                                  iconPath: "assets/aboutdeveloper.png"),
                              buildFloatingTransparentButton(
                                  backgroundColor: Colors.transparent,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                GoogleLocation()));
                                  },
                                  title: "About Venue",
                                  iconPath: "assets/aboutvenue.png"),
                              buildFloatingTransparentButton(
                                  backgroundColor: Colors.amber,
                                  onPressed: () {
                                    setState(() {
                                      activeWidget = getFestPage();
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  title: "About Fest",
                                  iconPath: "assets/aboutLogo.jpg"),
                              buildFloatingTransparentButton(
                                  backgroundColor: Colors.amber,
                                  onPressed: () {
                                    setState(() {
                                      activeWidget = getCollegePage();
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  title: "About College",
                                  iconPath: "assets/college.png"),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        context: context);
  }

  Widget buildFloatingTransparentButton(
      {Color backgroundColor,
      String title,
      String iconPath,
      Function onPressed,}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SlideTransition(
        position: CurvedAnimation(
          parent: floatingAboutButtonController,
          curve: Curves.easeInOut,
        ).drive(
          Tween<Offset>(
            end: const Offset(0.0, 0),
            begin: const Offset(0.0, 2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage(iconPath),
                  radius: 20.0,
                  backgroundColor: backgroundColor,
                ),
                SizedBox(
                  width: 8,
                ),
                InkWell(
                  splashColor: Colors.blue,
                  highlightColor: Colors.transparent,
                  onTap: onPressed,
                  child: Container(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontFamily: 'QuickSand',
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w800,
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
      ),
    );
  }

  Widget getFestPage() {
    return GestureDetector(
      onTap: () {
        setState(() {
          showDialogButton();
        });
      },
      child: AboutFest(),
    );
  }

  Widget getDeveloperPage() {
    return GestureDetector(
      onTap: () {
        showDialogButton();
      },
      child: Center(
        child: Text("Developer Page"),
      ),
    );
  }

  Widget getCollegePage() {
    return GestureDetector(
      onTap: () {
        showDialogButton();
      },
      child: SingleChildScrollView(
        physics: new BouncingScrollPhysics(),
        child: SizedBox(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/bvrit.png'),
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "${Data.aboutUsTitle}",
                style: Styles.heading.copyWith(
                        fontSize: widget.deviceSize.width*0.04,
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 5.0, bottom: 10.0),
              child: Text(
                Data.aboutUs,
                textAlign: TextAlign.justify,
                style: Styles.description,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                Text(Data.rowText1, textAlign: TextAlign.center, style: style),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: Colors.white30,
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                ),
                Text(Data.rowText2, textAlign: TextAlign.center, style: style),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: Colors.white30,
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                ),
                Text(Data.rowText3, textAlign: TextAlign.center, style: style),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: Colors.white30,
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                ),
                Text(Data.rowText4, textAlign: TextAlign.center, style: style),
              ],
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      Data.coursesOfferedTitle1,
                      style: Styles.heading.copyWith(
                        fontSize: widget.deviceSize.width*0.04,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      Data.coursesOffered1,
                      style: Styles.description,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      Data.coursesOfferedTitle2,
                      style: Styles.heading.copyWith(
                        fontSize: widget.deviceSize.width*0.04,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      Data.coursesOffred2,
                      style: Styles.description,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          curve: Interval(0.6, 1, curve: Curves.bounceOut),
          parent: fabcontroller,
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.place,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
                builder: (BuildContext context) => GoogleLocation()));
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          print("hello");
          showDialogButton();
        },
        child: activeWidget,
      ),
    );
  }
}

// import 'package:google_maps_flutter/google_maps_flutter.dart';
class GoogleLocation extends StatefulWidget {
  @override
  _GoogleLocationState createState() => _GoogleLocationState();
}

class _GoogleLocationState extends State<GoogleLocation> {
  GoogleMapController controller;
  Set<Marker> marker = {};
  @override
  void initState() {
    marker.add(new Marker(
        markerId: MarkerId("college Marker"),
        position: const LatLng(17.7253, 78.2572),
        infoWindow: InfoWindow(
            title: "B V Raju Institute of Technology",
            // snippet: "BVRIT",
            // anchor: Offset(0.5, 0.0)),
            onTap: () {})));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation:10.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.lightBlue,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.keyboard_backspace),
        ),
        centerTitle: true,
        title: Text("College Location",
            style: TextStyle(
                fontFamily: 'QuickSand', color: Colors.deepOrangeAccent)),
        elevation: 10.0,
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.5,

              width: double.infinity,

              child: GoogleMap(
                compassEnabled: true,

                // trafficEnabled: true,

                markers: marker,

                myLocationEnabled: true,

                initialCameraPosition: CameraPosition(
                    target: LatLng(17.725235, 78.257153), zoom: 16),

                onMapCreated: (controlle) {
                  setState(() {
                    controller = controlle;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum AboutState { Open, Close }

class AboutFest extends StatefulWidget {
  @override
  _AboutFestState createState() => _AboutFestState();
}

class _AboutFestState extends State<AboutFest> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Color(0xFF696ceb),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200.0,
              width: double.infinity,
              color: Color(0xFF3f25a0),
            ),
          ),
          Center(
            child: Image(
              image: AssetImage('assets/imagination.gif'),
              fit: BoxFit.scaleDown,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [],
            ),
          )
        ],
      ),
    );
  }
}
