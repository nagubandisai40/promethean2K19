import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:promethean_2k19/common/messageBox.dart';
import 'package:promethean_2k19/data_models/event_model.dart';
import 'package:promethean_2k19/screens/registeredEvents.dart';
import 'package:promethean_2k19/screens/registrationDiaolog.dart';
// import 'package:promethean_2k19/newLib/screens/registeredEvents.dart';
import 'package:promethean_2k19/utils/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationScreen extends StatefulWidget {
  final String organizingDepartment;
  final String eventName;

  const RegistrationScreen(
      {Key key, @required this.eventName, @required this.organizingDepartment})
      : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextStyle lableStyle = new TextStyle(
      fontSize: 20.0,
      letterSpacing: 0.5,
      color: Colors.black,
      fontWeight: FontWeight.bold);
  final TextStyle contentStyle =
      new TextStyle(fontSize: 15.0, letterSpacing: 0.7, color: Colors.black87);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _participants;
  String _referalEmailId;
  String _phonenum;
  String _name;
  Event event;
  Future _future;
  String _radiogroupValue = "";
  List<Widget> radioList = [];
  String rbvalue = "";
  int _fee = 0;
  Map<String, dynamic> temp = {
    'name': null,
    'email': null,
    'phonenum': null,
    'eventName': null,
    'eventType': null
  };
  String getTodayDate() {
    var now = new DateTime.now();
    return now.day.toString() +
        "-" +
        now.month.toString() +
        "-" +
        now.year.toString();
  }

  Future<Null> _getEvent({String eventName, String organizingDept}) async {
    print(eventName);
    // print("getting $eventName form $eventType");
    print(Urls.getEvent + "$organizingDept/$eventName.json");
    await http
        .get(Urls.getEvent + "$organizingDept/$eventName.json")
        .then((http.Response response) {
      print("entered Here");
      print(json.decode(response.body));
      Map<String, dynamic> fetchedData;
      fetchedData = json.decode(response.body);
      print(fetchedData);
      fetchedData.forEach((String uniqueId, dynamic value) {
        event = new Event(
            eventName: value['eventName'],
            organizedBy: value['organizedBy'],
            eventDesc: value['eventDesc'],
            eventRules: value['eventRules'],
            eventType: value['eventType'],
            eventDetails: value['eventDetails'],
            imageUrl: value['imageurl'],
            id: value['id'],
            cordinators: value['cordinators'],
            // eventRegsFee: value['eventRegsFee'],
            individualFee: value['individualFee'],
            organizerMailId: value['organizerMailId'],
            teamFee: value['teamFee'],
            organizedDept: value['organizedDept']);
        print("this is organised by ${event.eventType}");
        print('$fetchedData');
      });
    }); //get
  }

  @override
  void initState() {
    _future = _getEvent(
        eventName: widget.eventName,
        organizingDept: widget.organizingDepartment);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceheight = MediaQuery.of(context).size.height;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    Future<Null> _submitForm(BuildContext buildContext) async {
      if (_formKey.currentState.validate()) {
        temp['eventName'] = event.eventName;
        temp['eventType'] = event.eventType;
        _formKey.currentState.save();
        print(temp);
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        String uid = _prefs.get('uid');
        print("user id is : $uid");
        _formKey.currentState.save();

        final Map<String, dynamic> _sendEventData = {
          'cordinators': event.cordinators,
          'eventDesc': event.eventDesc,
          'eventDetails': event.eventDetails,
          'eventName': event.eventName,
          'eventRules': event.eventRules,
          'eventType': event.eventType,
          'id': event.id,
          'imageUrl': event.imageUrl,
          'organizedBy': event.organizedBy,
          'organizerMailId': event.organizerMailId,
          'fee': rbvalue.toLowerCase() == "team"
              ? _fee = event.teamFee
              : _fee = event.individualFee,
          'teamMembers': _participants,
          'referalEmailId': _referalEmailId
        };
        setState(() {
          new LoadingMessageBox(context, 'Registration Process', '').show();
        });

        try {
          // we first check wether the person is registered or not.
          var response = await http.get(
              "https://promethean2k19-68a29.firebaseio.com/users/$uid/registeredEvents/${event.eventName}.json");
          var decodedResponse = json.decode(response.body);
          if (decodedResponse == null) {
            try {
              http
                  .post(
                      Urls.getUsers +
                          '/$uid/registeredEvents/${event.eventName}.json',
                      body: json.encode(_sendEventData))
                  .catchError((error) {
                Navigator.of(context).pop();
                new MessageBox(
                        context, "Registration Terminated", "Network Error !")
                    .show();
              }).then((http.Response response) async {
                print(temp);
                print(Urls.getDeptRegisters +
                    getTodayDate() +
                    '/${event.organizedDept}.json');
                await http
                    .post(
                        Urls.getDeptRegisters +
                            getTodayDate() +
                            '/${event.organizedDept}.json',
                        body: json.encode(temp))
                    .then((http.Response response) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(builder: (BuildContext context) {
                    return Scaffold(
                        appBar: new AppBar(
                          leading: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            color: Colors.black,
                          ),
                          backgroundColor: Colors.white,
                          elevation: 3.0,
                          title: new Text(
                            "Registered Events",
                            style: new TextStyle(
                              color: Colors.black,
                              fontFamily: 'bebas-neue',
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                        body: RegisteredEvents(uid));
                  }));
                });
                // await http.post(Urls.getRoot,body: );
              });
            } catch (e) {
              print("error form second future");
            }
          } else {
            Navigator.of(context).pop();
            Scaffold.of(buildContext).showSnackBar(SnackBar(
              content: Text(
                "Already registerd to this event.",
                style: TextStyle(fontSize: 13.0),
              ),
              action: SnackBarAction(
                label: 'Check Registered Events',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(builder: (BuildContext context) {
                    return Scaffold(
                        appBar: new AppBar(
                          leading: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.black,
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 3.0,
                          title: new Text(
                            "Registered Events",
                            style: new TextStyle(
                              color: Colors.black,
                              fontFamily: 'bebas-neue',
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                        body: RegisteredEvents(uid));
                  }));
                },
              ),
            ));
          }
        } catch (error) {
          print("Catght error is : \n$error");
          Navigator.of(context).pop();
//        Navigator.of(context).pop();
          new MessageBox(
                  buildContext,
                  "Registration Process Terminated (No Internet / Proxifed Wifi).",
                  "Network Error")
              .show();
          return null;
        }
        return null;
      }

//
    }

    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        elevation: 3.0,
        title: new Text(
          "Registration",
          style: new TextStyle(
            color: Colors.black,
            fontFamily: 'bebas-neue',
            fontSize: 25.0,
          ),
        ),
      ),
      body: FutureBuilder<Event>(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(
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
                );

              case ConnectionState.done:
                if (snapshot.hasError) {
                  print(snapshot.error);
                  Future.delayed(const Duration(milliseconds: 1000)).then((_) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "No Internet Connection.",
                        style: TextStyle(fontSize: 13.0),
                      ),
                      action: SnackBarAction(
                        textColor: Colors.pink,
                        label: 'Ok',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ));
                  });
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Please check your device network connection !!",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                return buildregistartionBody(targetPadding, deviceheight,
                    deviceWidth, _submitForm, context);
            }
            // this doesnt come accross
            return Container();
          }
          // buildregistartionBody(targetPadding, deviceheight, deviceWidth, _submitForm)

          ),
    );
  }

  Widget buildregistartionBody(double targetPadding, double deviceheight,
      double deviceWidth, Function _submitForm, BuildContext buildContext) {
    // List<Widget> list = [];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Form(
        key: _formKey,
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: 7,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                print("build poster");
                return _buildPoster(
                    targetPadding, deviceheight, event.imageUrl);
              } else if (index <= 5) {
                print("build 5 $index");

                return customeCardTile(
                  title: [
                    "Organized By",
                    "Event Name",
                    "Event Description",
                    "Event Rules",
                    "Event Details"
                  ][index - 1],
                  content: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      style: contentStyle,
                      children: [
                        TextSpan(text: event.getListofProperties()[index - 1]),
                      ],
                    ),
                  ),
                );
              } else {
                print("Build last two");
                return Column(
                  children: <Widget>[
                    _buildCordinators(deviceWidth, event.cordinators),
                    Hero(
                      child: RaisedButton(
                        onPressed: () {
                          eventDescriptionScreen();
                        },
                      ),
                      tag: "HeroButton",
                    ),
                    // _buildRegitrationSection(_submitForm, buildContext),
                  ],
                );
              }
            }),
      ),
    );
  }

  Widget customeCardTile({String title, Widget content}) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              title,
              style: lableStyle,
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.black12,
          ),
          ListTile(
            title: Card(
              elevation: 15.0,
              child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  child: content),
            ),
          ),
        ],
      ),
    );
  }

  Widget _radiobuilder(String _radiogroup) {
    return Row(
      children: <Widget>[
        Radio(
          groupValue: _radiogroupValue,
          onChanged: (String value) {
            // print(value);
            setState(() {
              // print(value);
              _radiogroupValue = value;
              rbvalue = value;
              if (rbvalue.toLowerCase() == "team") {
                _fee = event.teamFee;
              } else if (rbvalue.toLowerCase() == "individual") {
                _fee = event.individualFee;
              }
              print(rbvalue);
            });
            // setState(() {
            //   _radiocolor==Colors.green?_radiocolor=Colors.transparent:_radiocolor=Colors.green;
            // });
          },
          value: _radiogroup,
          activeColor: Colors.green,
        ),
        Text(
          _radiogroup,
          style: new TextStyle(fontSize: 16.0),
        )
      ],
    );
  }

  Widget _buildRegitrationSection(
      Function _submitForm, BuildContext buildContext) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Divider(
            height: 2.0,
            color: Colors.black12,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Registration Section',
              style: lableStyle,
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.black12,
          ),
          ListTile(
            title: Card(
              elevation: 15.0,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: getRadioButtonList()),
              ),
            ),
          ),
          ListTile(
            title: Card(
              elevation: 15.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter your phone number";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter your Phone Number',
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Colors.black54)),
                  onSaved: (String value) {
                    setState(() {
                      temp['phonenum'] = value;
                      print("Phone number:" + value);
                    });
                  },
                ),
              ),
            ),
          ),
          ListTile(
            title: Card(
              elevation: 15.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please Enter youe Email Id";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter your Email Id',
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Colors.black54)),
                  onSaved: (String value) {
                    setState(() {
                      temp['email'] = value;
                      print("mail:" + value);
                    });
                  },
                ),
              ),
            ),
          ),
          ListTile(
            title: Card(
              elevation: 15.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please Enter the Teammate names";
                    }
                    return null;
                  },
                  enabled: rbvalue.toLowerCase() == "team" ? true : false,
                  decoration: InputDecoration(
                      hintText: 'Enter Name of the Teammates separated ","',
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Colors.black54)),
                  onSaved: (String value) {
                    setState(() {
                      _participants = value;
                      print("participanta value" + value);
                    });
                  },
                ),
              ),
            ),
          ),
          ListTile(
            title: Card(
              elevation: 15.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please Enter your Email";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter Name',
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Colors.black54)),
                  onSaved: (String value) {
                    setState(() {
                      temp['name'] = value;
                      print("name:" + value);
                    });
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                color: Colors.transparent,
                elevation: 15.0,
                child: CupertinoButton(
                  color: Colors.blue,
                  onPressed: () {
                    // _submitForm(buildContext);
                  },
                  child: Text('Register'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getRadioButtonList() {
    if (event.eventType.toLowerCase() == "team") {
      radioList = [_radiobuilder("Team")];
    } else if (event.eventType.toLowerCase() == "individual") {
      radioList = [_radiobuilder("Individual")];
    } else {
      radioList = [_radiobuilder("Team"), _radiobuilder("Individual")];
    }

    return radioList;
  }

  Widget _buildPoster(double targetPadding, double height, imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        height: height * 0.2,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
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
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _buildCordinators(double width, Map<String, dynamic> map) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Event Co-ordinators',
              style: lableStyle,
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.black12,
          ),
          ListTile(
            title: Card(
              elevation: 15.0,
              child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("Co-ordinator 1: " + map.keys.toList()[0]),
                          IconButton(
                              icon: Icon(Icons.call),
                              onPressed: () {
                                _launchUrl(map.values.toList()[0].toString());
                                print(map.values.toList()[0].toString());
                              })
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("Co-ordinator 2: " + map.keys.toList()[1]),
                          IconButton(
                            icon: Icon(Icons.call),
                            onPressed: () {
                              _launchUrl(map.values.toList()[1].toString());
                            },
                          )
                        ],
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  void _launchUrl(String phoneno) async {
    if (await canLaunch('tel:' + phoneno)) {
      launch('tel:' + phoneno);
    } else {
      print("url launch exception caught");
      throw "Could not launch " + phoneno;
    }
  }

  toCallSetState(Function onpressed) {
    setState(() {
      onpressed();
    });
  }

  eventDescriptionScreen() {
    TextStyle hintStyle =
        TextStyle(fontFamily: 'QuickSand', fontSize: 15.0, color: Colors.black);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new PopScreen(
              event: event, hintStyle: hintStyle, state: toCallSetState);
        });
  }
}
