import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:promethean_2k19/screens/introToimagination.dart';

class IntroScreens extends StatefulWidget {
  @override
  _IntroScreensState createState() => _IntroScreensState();
}

class _IntroScreensState extends State<IntroScreens> {
  List<String> imagePath = [
    "assets/welcome.png",
    "assets/event.jpg",
    "assets/alerts.jpg",
    "assets/maps.jpg",
    "assets/win1.jpg",
  ];
  List<String> title = [
    "Welcome",
    "Event Registration",
    "Alerts",
    "Location",
    "Daily Notifications",
    // "Payment",
  ];
  List<String> description = [
    "Promethean is the biggest Annual Technical Symposium of BVRIT, continuing the Saga this Year also, It is ready To Hit You with All-New Events,Workshops,With Exciting Prize Money And Lots More. So Don't Miss The Chance Get Registered Yourselves Today",
    "Events Description",
    "Alerts Description",
    "College Location",
    "Notifications Description",
  ];
  List<Color> backgroundColors = [
    Color(0xFFf6f6f6),
    Color(0xFF766de7),
    Colors.white,
    Color(0xFF5adceb),
    Colors.transparent
  ];
  int index = 0;

  Widget mainWidget(
      {String title,
      String description,
      String imagepath,
      Color backgroundColor}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.03),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 3.0,
                              spreadRadius: 1.0)
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.55),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          height: MediaQuery.of(context).size.width * 0.55,
                          decoration: ShapeDecoration(
                              shape: CircleBorder(), color: Colors.white),
                          child: Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.0111),
                            child: DecoratedBox(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width * 0.55),
                                  child: Image.asset(
                                    imagepath,
                                    fit: BoxFit.scaleDown,
                                  )),
                              decoration: ShapeDecoration(
                                color: backgroundColor,
                                shape: CircleBorder(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.018,
                        bottom: MediaQuery.of(context).size.height * 0.038),
                    child: Text(title,
                        style:
                            TextStyle(fontFamily: 'QuickSand', fontSize: 25)),
                  ),
                ],
              ),
              elevation: 4,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.042),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                Text(
                  description,
                textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'QuickSand',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.loose,
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            // color: Color(0xFF696ceb),
            width: double.infinity,
            child: PageView.builder(
              // controller: ,
              onPageChanged: (value) {
                setState(() {
                  this.index = value;
                  // print(index);
                });
              },

              itemBuilder: (BuildContext context, int index) {
                // print(imagePath[index] + "$index");
                if (index != title.length)
                  return Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: mainWidget(
                          title: title[index],
                          description: description[index],
                          imagepath: imagePath[index],
                          backgroundColor: backgroundColors[index]),
                    ),
                  );
                return IntroToImagination();
              },

              itemCount: title.length + 1,
            ),
          ),
          index != title.length
              ? Positioned(
                  bottom: 3,
                  child: DotsIndicator(
                    dotsCount: title.length,
                    position: index,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
