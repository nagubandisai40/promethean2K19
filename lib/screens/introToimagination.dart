import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promethean_2k19/screens/authScreen.dart';

class IntroToImagination extends StatefulWidget {
  @override
  _IntroToImaginationState createState() => _IntroToImaginationState();
}

class _IntroToImaginationState extends State<IntroToImagination>
    with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  AnimationController buttoncontroller;
  
  @override
  void initState() {
    buttoncontroller = new AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    controller = new AnimationController(
        duration: const Duration(seconds: 2), vsync: this);
    animation = new CurvedAnimation(
      parent: controller,
      curve: new Interval(0.0, 1, curve: Curves.elasticOut),
    );
    controller.forward();
    buttoncontroller.forward();
    super.initState();
  }

  @override
  void dispose() {
    buttoncontroller.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF696ceb),
        width: double.infinity,
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
            SlideTransition(
              position: animation.drive(Tween<Offset>(
                begin: const Offset(0.0, 3.7),
                end: const Offset(0.0, 1.5),
              )),
              child: Text(
                "Intro To Imagination",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'QuickSand',
                    fontSize: 50.0,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ScaleTransition(
                  scale: CurvedAnimation(
                      parent: buttoncontroller,
                      curve: Interval(0.6, 0.9, curve: Curves.fastOutSlowIn)),
                  child: RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "Done",
                            style: TextStyle(
                              fontFamily: 'QuickSand',
                              fontSize: 20.0,
                              color: Color(0xFF3f25a0),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,color: Colors.black,),
                        ],
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(CupertinoPageRoute(
                          builder: (BuildContext context) => AuthScreen()));
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


/*{
  "cordinators" : {
    "pun" : 9441095948,
    "sai" : 9849210151
  },
  "eventDesc" : "EVENTDESCRIPTION",
  "eventDetails" : "DETAILS",
  "eventName" : "Event1",
  "eventRules" : "EVENTRULES",
  "eventType" : "Team",
  "id" : "EVENTID",
  "imageurl" : "https://firebasestorage.googleapis.com/v0/b/promethean2k19-68a29.appspot.com/o/m.jpg?alt=media&token=8a4cca8d-c799-4065-97dd-efe89d61655b",
  "individualFee" : 200,
  "organizedBy" : "club1",
  "organizedDept" : "IT",
  "organizerMailId" : "nagubandisai04@gmail.com",
  "teamFee" : 500
}
 */