import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promethean_2k19/data_models/event_model.dart';
import 'package:http/http.dart' as http;
import 'package:promethean_2k19/screens/registration_screen.dart';
import 'package:promethean_2k19/utils/urls.dart';

class AllEventScreen extends StatefulWidget {
  final String deptName;

  const AllEventScreen({Key key,@required this.deptName}) : super(key: key);
  @override
  _AllEventScreenState createState() => _AllEventScreenState();
}

class _AllEventScreenState extends State<AllEventScreen> {
  List<Event> allEvents = [];

  @override
  void initState() {
    super.initState();
  }

  Future<Null> _getAllEvent({String deptName}) async {
    print("getting all events form $deptName");
    await http
        .get(Urls.getEvent + "$deptName.json")
        .then((http.Response response) {
      Map<String, dynamic> fetchedData = {};
      print("entered Here");
      print(json.decode(response.body));
      fetchedData = json.decode(response.body);
      fetchedData.forEach((String uniqueId, dynamic v) {
        v.forEach((String k, dynamic value) {
          final Event event = new Event(
            organizedDept: value['organizedDept'],
            eventType: value['eventType'],
              eventName: value['eventName'],
              organizedBy: value['organisedBy'],
              eventDesc: value['eventDesc'],
              eventRules: value['eventRules'],
              eventDetails: value['eventDetails'],
              imageUrl: value['imageurl'],
              id: value['id'],
              cordinators: value['cordinators'],
              // eventRegsFee: value['eventRegsFee'], 
              teamFee: value['teamFee'],
               individualFee: value['individualFee'], 
               organizerMailId: value['oraganizerMailId']);
          allEvents.add(event);
        });
        print('$fetchedData');
      });
    }); //get
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          widget.deptName+" Events",
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'bebas-neue',
            color: Colors.black,
          ),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext _context) {
    return Center(
      child: FutureBuilder(
        future: _getAllEvent(deptName: widget.deptName),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return _getOnLoading();
            case ConnectionState.done:
              if (snapshot.hasError) {
                print("data:${snapshot.data}");
                print("${snapshot.error}");
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Something went Wrong !!"),
                          ),
                          RaisedButton.icon(
                            color: Colors.blue,
                            icon: Icon(
                              Icons.refresh,
                              color: Colors.yellow,
                            ),
                            onPressed: () {
                              setState(() {});
                            },
                            label: Text(
                              "Try Again",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return _getfectchedEvent(allEvents);
          }
          return Container();
        },
      ),
    );
  }

  ListView _getOnLoading() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return LoadingEvents();
      },
      itemCount: 2,
    );
  }

  ListView _getfectchedEvent(List<Event> events) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Events(
          eventType: widget.deptName,
          event: events[index],
        );
      },
      itemCount: events.length,
    );
  }
}

class Events extends StatelessWidget {
  final Event event;
  final String eventType;

  const Events({Key key, this.event, this.eventType}) : super(key: key);

  final TextStyle lableStyle =
      const TextStyle(fontSize: 20.0, color: Colors.black, letterSpacing: 1.5);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (BuildContext context) => RegistrationScreen(
                  organizingDepartment: event.organizedDept,
                  eventName: event.eventName.trim(),
                 
                )));
      },
      child: Padding(
        padding: const EdgeInsets.only(
            top: 15.0, left: 10.0, right: 10.0, bottom: 5.0),
        child: Card(
          color: Colors.white,
          elevation: 10.0,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      child: Image.network(
                        event.imageUrl,
                        fit: BoxFit.fitHeight,
                      ),
                      width: double.infinity,
                      height: 170.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: RichText(
                    text: TextSpan(
                        text:  event.eventName + "\n",
                        style: lableStyle.copyWith(
                          fontSize: 20.0,
                          fontFamily: 'bebas-neue',
                          letterSpacing: 1.2,
                        ),
                        children: [
                          TextSpan(
                            text: event.organizedBy,
                            style: lableStyle.copyWith(
                              fontSize: 20.0,
                              fontFamily: 'bebas-neue',
                              letterSpacing: 1.2,
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingEvents extends StatefulWidget {
  @override
  _LoadingEventsState createState() => _LoadingEventsState();
}

class _LoadingEventsState extends State<LoadingEvents>
    with SingleTickerProviderStateMixin {
  AnimationController animController;

  void iterator() {
    animController.reset();

    animController.forward().then((f) {
      animController.reverse().then((d) {
        iterator();
      });
    });
  }

  @override
  void initState() {
    animController = new AnimationController(
      lowerBound: 0.0555,
      upperBound: 0.1555,
      vsync: this,
      duration: const Duration(
        milliseconds: 2000,
      ),
    );

    iterator();
    super.initState();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animController,
      child: Container(),
      builder: (BuildContext context, Widget child) {
        return Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
          child: Card(
            color: Colors.white,
            elevation: 10.0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        color: Colors.blue.withOpacity(animController.value),
                        width: double.infinity,
                        height: 170.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        color: Colors.blue.withOpacity(animController.value),
                        width: 160.0,
                        height: 20.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        color: Colors.blue.withOpacity(animController.value),
                        width: 200.0,
                        height: 20.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
