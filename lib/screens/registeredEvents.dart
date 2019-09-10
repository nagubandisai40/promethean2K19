import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

class RegisteredEvents extends StatefulWidget {

  final String uid;

  const RegisteredEvents(this.uid, {Key key}) : super(key: key);

  @override
  _RegisteredEventsState createState() => _RegisteredEventsState();
}

class _RegisteredEventsState extends State<RegisteredEvents> {
  List<Widget> slidingWidgets = [];

  Future<Null> getregisteredEvents(String uid) async {
    await http
        .get(
            "https://promethean2k19-68a29.firebaseio.com/users/$uid/registeredEvents.json")
        .then((http.Response response) {
//        List<RegisteredEventsModel> registeredEvents;
      Map<String, dynamic> fectheddata = json.decode(response.body);
      // print(fectheddata);
      fectheddata.forEach((String key, dynamic value) {
        // print(value);
        // print(value['-Lnslx6RBh7ZrWXNVP3J']['eventType']);
        Map<String, dynamic> temp = value;
        // temp.forEach(f)
        temp.forEach((String key, dynamic value) {
          // pageOffset==0?pageOffset=-1:pageOffset=0;
          slidingWidgets.add(SlidingCards(
            eventType: value['eventType'],
            fee: value['fee'].toString(),
            imageUrl: value['imageUrl'],
            offset: pageOffset,
            name: value['eventName'],
          ));
          print(slidingWidgets.length);
        });
        //  slidingWidgets.add(SlidingCards(
        //     eventType: 'eventType',
        //     fee: '33',
        //     imageUrl:'assets/steak_on_cooktop.jpg',
        //     offset: -1,
        //     name: 'eventName',
        //   ));

      });
    });
  }

  PageController pageController;
  double pageOffset = 0;
  Future _future;
  @override
  initState() {
    _future = getregisteredEvents(widget.uid);
    pageController = new PageController(viewportFraction: 0.8);
    pageController.addListener(() {
      setState(() => pageOffset = pageController.page);
    });
    super.initState();
  }

  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<dynamic>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: Text("Loading...."),
              );
            case ConnectionState.done:
              if (snapshot.hasData) print("${snapshot.data}");
              if (snapshot.hasError) {
                return Center(
                  child: Text("You have not registered for any events yet."),
                );
              } else
                return Center(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: PageView(
                          controller: pageController,
                          children: slidingWidgets,
                          )),
                );
          }

          return null;
        },
      ),
    );
  }
}

class SlidingCards extends StatelessWidget {
  final String name, imageUrl, fee, eventType;
  final double offset;

  const SlidingCards(
      {Key key,
      @required this.name,
      @required this.imageUrl,
      @required this.fee,
      @required this.eventType,
      this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));
    return Transform.translate(
      offset: new Offset(-18 * gauss * offset.sign, 0),
      child: Card(
        elevation: 8.0,
        margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 24.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
              child: Image.asset(
                'assets/steak_on_cooktop.jpg',
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.none,
                alignment: Alignment(-offset.abs(), 0),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: CardContent(
                eventName: name,
                date: eventType.toUpperCase(),
                fee: fee,
                offset: gauss,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final String eventName;
  final String date;
  final String fee;
  final double offset;

  const CardContent({Key key, this.eventName, this.date, this.fee, this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Transform.translate(
            offset: Offset(8 * offset, 0),
            child: Text(eventName, style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 8),
          Transform.translate(
            offset: Offset(32 * offset, 0),
            child: Text(
              date,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Spacer(),
          Row(
            children: <Widget>[
              Transform.translate(
                offset: Offset(48 * offset, 0),
                child: RaisedButton(
                  color: Color(0xFF162A49),
                  child: Transform.translate(
                    offset: Offset(0, 0),
                    child: Text('Registered'),
                  ),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  onPressed: () {},
                ),
              ),
              Spacer(),
              Transform.translate(
                offset: Offset(18 * offset, 0),
                child: Text(
                  "\$" + fee,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(width: 16),
            ],
          )
        ],
      ),
    );
  }
}
