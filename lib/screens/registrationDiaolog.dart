import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promethean_2k19/data_models/event_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/messageBox.dart';
import '../utils/urls.dart';
import 'registeredEvents.dart';
import 'package:http/http.dart' as http;

class PopScreen extends StatefulWidget {
  const PopScreen({
    Key key,
    @required this.event,
    @required this.hintStyle,
    @required this.state,
  }) : super(key: key);

  final Event event;
  final TextStyle hintStyle;
  final Function state;

  @override
  _PopScreenState createState() => _PopScreenState();
}

class _PopScreenState extends State<PopScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isIndividual = true;
  String fee;
  Event event;
  bool _autoValidate=false;
  Map<String, dynamic> temp = {
    'name': null,
    'email': null,
    'phonenum': null,
    'eventName': null,
    'eventType': null,
    'organizedDept': null,
    'teamNames': null,
    'amount': null,
  };

  @override
  void initState() {
    event = widget.event;
    super.initState();
  }

  String getTodayDate() {
    var now = new DateTime.now();
    return now.day.toString() +
        "-" +
        now.month.toString() +
        "-" +
        now.year.toString();
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }


  Future<Null> _submitForm(BuildContext buildContext) async {
    // if (_formKey.currentState.validate()) {
    //   temp['eventName'] = event.eventName;
    //   temp['eventType'] = event.eventType;
    //   _formKey.currentState.save();
    //   print("In _submitForm and the temp is:");
    //   print(temp);
    // }
    // SharedPreferences _prefs = await SharedPreferences.getInstance();
    //   String uid = _prefs.get('uid');
    // print("https://promethean2k19-68a29.firebaseio.com/users/$uid/registeredEvents/${event.eventName}${event.organizedDept}.json");

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
        'fee': temp['amount'],
        'teamMembers':temp['teamNames'],
        'referalEmailId': temp['email'],
        'organizedDept':event.organizedDept
      };
      print("The Sender's Data is as follows:");
      print(_sendEventData);
      setState(() {
        new LoadingMessageBox(context, 'Registration Process', '').show();
      });

      try {
        // we first check wether the person is registered or not.
        var response = await http.get(
            "https://promethean2k19-68a29.firebaseio.com/users/$uid/registeredEvents/${event.eventName}${event.organizedDept}.json");
        var decodedResponse = json.decode(response.body);
        if (decodedResponse == null) {
          try {
            http
                .post(
                    Urls.getUsers +
                        '/$uid/registeredEvents/${widget.event.eventName}${event.organizedDept}.json',
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
                  '/${widget.event.organizedDept}.json');
              await http
                  .post(
                      Urls.getDeptRegisters +
                          getTodayDate() +
                          '/${widget.event.organizedDept}.json',
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
        new MessageBox(
                buildContext,
                "Registration Process Terminated (No Internet / Proxifed Wifi).",
                "Network Error")
            .show();
        return null;
      }
      return null;
    }else{
      setState(() {
        _autoValidate=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.0)),
        width: MediaQuery.of(context).size.width * 0.9,
        // height: MediaQuery.of(context).size.height * 0.8,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              width: double.infinity,
              // color: Colors.amber,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.045,
                  ),
                  Container(
                    // color: Colors.amber,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.blue,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3.0)),
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.08,
                        bottom: MediaQuery.of(context).size.height * 0.02,
                      ),
                      // height: MediaQuery.of(context).size.height * 0.6,
                      width: double.infinity,
                      // child: _buildColumn(context, isTeam, fee, isIndividual),
                      // color: Colors.black,
                      child: _buildRegistrationSection(context),
                    ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: MediaQuery.of(context).size.height * 0.06,
              foregroundColor: Colors.blue,
              child: FlutterLogo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormTeam() {
    temp['amount'] = event.teamFee;
    temp['organizedDept'] = event.organizedDept;
    return Material(
      child: Container(
        child: Form(
          autovalidate: _autoValidate,
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "User Registration Form",
                  style: widget.hintStyle.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: MediaQuery.of(context).size.width * 0.045),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter Name";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter your Name',
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Colors.black54)),
                  onSaved: (String value) {
                    setState(() {
                      temp['name'] = value;
                      // temp['phonenum'] = value;
                      print("Name:" + value);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                  decoration: InputDecoration(
                      hintText: 'Enter your Email',
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Colors.black54)),
                  onSaved: (String value) {
                    setState(() {
                      temp['email'] = value;
                      // temp['phonenum'] = value;
                      print("Email:" + value);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
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
                      // temp['phonenum'] = value;
                      print("Phone number:" + value);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter Teammate names";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter your Teammate Names',
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Colors.black54)),
                  onSaved: (String value) {
                    setState(() {
                      temp['teamNames'] = value;
                      // temp['phonenum'] = value;
                      print("Teammate Names:" + value);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormIndividual() {
    temp['amount'] = event.individualFee;
    temp['organizedDept'] = event.organizedDept;
    return Material(
      child: Container(
        child: Form(
          autovalidate: _autoValidate,
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "User Registration Form",
                  style: widget.hintStyle.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: MediaQuery.of(context).size.width * 0.045),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter Name";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter your Name',
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Colors.black54)),
                  onSaved: (String value) {
                    setState(() {
                      temp['name'] = value;
                      // temp['phonenum'] = value;
                      print("Name:" + value);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                  decoration: InputDecoration(
                      hintText: 'Enter your Email',
                      hintStyle:
                          TextStyle(fontSize: 15.0, color: Colors.black54)),
                  onSaved: (String value) {
                    setState(() {
                      temp['email'] = value;
                      // temp['phonenum'] = value;
                      print("Email:" + value);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
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
                      // temp['phonenum'] = value;
                      print("Phone number:" + value);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndividualForm(BuildContext context) {
    print("Entered _buildIndividual Form");
    return Column(
      children: <Widget>[
        _buildTextFormIndividual(),
        Card(
          elevation: 0,
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  backgroundColor: Colors.blue,
                  label: Text(
                    "Individual",
                    style: widget.hintStyle.copyWith(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Registration Fee " + widget.event.individualFee.toString(),
                    style: widget.hintStyle,
                  ),
                ),
              ),
              Wrap(
                children: <Widget>[
                  Text(
                    "By Pressing Register User will be Registered and ©Promethene2K19 will send the details to conserned Co-Ordinator for Validation.",
                    style: TextStyle(
                        fontFamily: "QuickSand",
                        fontSize: 8.0,
                        color: Colors.grey),
                  )
                ],
              ),
              Card(
                // color: Colors.transparent,
                elevation: 0,
                child: Container(
                    child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ActionChip(
                      backgroundColor: Colors.grey,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      label: Text(
                        "Cancel",
                        style: widget.hintStyle,
                      ),
                    ),
                    ActionChip(
                      backgroundColor: Colors.blue,
                      onPressed: () {
                        _submitForm(context);
                      },
                      label: Text(
                        "Register",
                        style: widget.hintStyle.copyWith(
                          color: Colors.white,
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  ],
                )),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTeamForm(BuildContext context) {
    print("Entered _buildTeamForm");
    return Column(
      children: <Widget>[
        Card(
          elevation: 0,
          child: Column(
            children: <Widget>[
              _buildTextFormTeam(),
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  backgroundColor: Colors.blue,
                  label: Text(
                    "Team",
                    style: widget.hintStyle.copyWith(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Registration Fee " + widget.event.teamFee.toString(),
                    style: widget.hintStyle,
                  ),
                ),
              ),
              Wrap(
                children: <Widget>[
                  Text(
                    "By Pressing Register User will be Registered and ©Promethene2K19 will send the details to conserned Co-Ordinator for Validation.",
                    style: TextStyle(
                        fontFamily: "QuickSand",
                        fontSize: 8.0,
                        color: Colors.grey),
                  )
                ],
              ),
              Card(
                // color: Colors.transparent,
                elevation: 0,
                child: Container(
                    child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ActionChip(
                      backgroundColor: Colors.grey,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      label: Text(
                        "Cancel",
                        style: widget.hintStyle,
                      ),
                    ),
                    ActionChip(
                      backgroundColor: Colors.blue,
                      onPressed: () {
                        _submitForm(context);
                      },
                      label: Text(
                        "Register",
                        style: widget.hintStyle.copyWith(
                          color: Colors.white,
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  ],
                )),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBothForm(BuildContext context) {
    print("Entered _buildBothForm");
    fee = isIndividual
        ? widget.event.individualFee.toString()
        : widget.event.teamFee.toString();
    print(fee);
    return Column(
      children: <Widget>[
        Card(
          elevation: 0,
          child: Column(
            children: <Widget>[
              isIndividual
                  ? _buildTextFormIndividual()
                  : _buildTextFormTeam(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ActionChip(
                    backgroundColor: isIndividual ? Colors.blue : Colors.grey,
                    label: Text('Individual'),
                    onPressed: () {
                      setState(() {
                        isIndividual = !isIndividual;
                      });
                    },
                  ),
                  ActionChip(
                    backgroundColor:
                        !isIndividual ? Colors.blue : Colors.grey,
                    label: Text('Team'),
                    onPressed: () {
                      setState(() {
                        isIndividual = !isIndividual;
                      });
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Registration Fee " + fee,
                    style: widget.hintStyle,
                  ),
                ),
              ),
              Wrap(
                children: <Widget>[
                  Text(
                    "By Pressing Register User will be Registered and ©Promethene2K19 will send the details to conserned Co-Ordinator for Validation.",
                    style: TextStyle(
                        fontFamily: "QuickSand",
                        fontSize: 8.0,
                        color: Colors.grey),
                  )
                ],
              ),
              Card(
                // color: Colors.transparent,
                elevation: 0,
                child: Container(
                    child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ActionChip(
                      backgroundColor: Colors.grey,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      label: Text(
                        "Cancel",
                        style: widget.hintStyle,
                      ),
                    ),
                    ActionChip(
                      backgroundColor: Colors.blue,
                      onPressed: () {
                        _submitForm(context);
                      },
                      label: Text(
                        "Register",
                        style: widget.hintStyle.copyWith(
                          color: Colors.white,
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  ],
                )),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildRegistrationSection(context) {
    if (widget.event.eventType.toLowerCase() == "individual") {
      return _buildIndividualForm(context);
    } else if (widget.event.eventType.toLowerCase() == "team") {
      return _buildTeamForm(context);
    } else {
      return _buildBothForm(context);
    }
  }

// Widget _buildColumn(
//       BuildContext context, bool isTeam, int fee, bool isIndividual) {
//     return Column(
//       children: <Widget>[
//         Card(
//           elevation: 0.0,
//           // color: Colors.black,
//           child: SingleChildScrollView(
//             child: Container(
//               // color: Colors.red,
//               margin: EdgeInsets.symmetric(horizontal: 20.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   "User Registration Form",
//                   "Enter Name",
//                   "Enter Email",
//                   "Enter Phone Number",
//                   "Enter Team Name",
//                   widget.event.eventType,
//                   'fee',
//                   "By Pressing Register User will be Registered and ©Promethene2K19 will send the details to conserned Co-Ordinator for Validation."
//                 ].map((string) {
//                   if (string == "User Registration Form") {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: Text(
//                         string,
//                         style: widget.hintStyle.copyWith(
//                             fontWeight: FontWeight.w800,
//                             fontSize: MediaQuery.of(context).size.width * 0.04),
//                       ),
//                     );
//                   } else if (string == "Enter Name" ||
//                       string == "Enter Email" ||
//                       string == "Enter Phone Number")
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: TextField(
//                         decoration: InputDecoration(
//                           hintText: string,
//                           hintStyle: widget.hintStyle,
//                         ),
//                       ),
//                     );
//                   if (string == "Enter Team Name") {
//                     return isTeam
//                         ? Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: TextField(
//                               decoration: InputDecoration(
//                                 hintText: string,
//                                 hintStyle: widget.hintStyle,
//                               ),
//                             ),
//                           )
//                         : Container();
//                   }

//                   if (string == "Individual" || string == "Team") {
//                     print("true");
//                     fee = string == 'Team'
//                         ? widget.event.teamFee
//                         : widget.event.individualFee;
//                     return Align(
//                       alignment: Alignment.centerLeft,
//                       child: Chip(
//                         backgroundColor: Colors.blue,
//                         label: Text(
//                           string,
//                           style: widget.hintStyle.copyWith(color: Colors.white),
//                         ),
//                       ),
//                     );
//                   } else if (string == "Both")
//                     return Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: <Widget>[
//                         ActionChip(
//                           backgroundColor:
//                               isIndividual ? Colors.blue : Colors.grey,
//                           label: Text('Individual'),
//                           onPressed: () {
//                             widget.state(() {
//                               isIndividual = !isIndividual;
//                               fee = widget.event.individualFee;
//                               print(fee);
//                             });
//                           },
//                         ),
//                         ActionChip(
//                           backgroundColor: isTeam ? Colors.blue : Colors.grey,
//                           label: Text('Team'),
//                           onPressed: () {
//                             widget.state(() {
//                               isTeam = !isTeam;
//                               fee = widget.event.teamFee;
//                               print(fee);
//                             });
//                           },
//                         ),
//                       ],
//                     );
//                   if (string == 'fee') {
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           "Registration Fee $fee",
//                           style: widget.hintStyle,
//                         ),
//                       ),
//                     );
//                   } else
//                     return Wrap(
//                       children: <Widget>[
//                         Text(
//                           string,
//                           style: TextStyle(
//                               fontFamily: "QuickSand",
//                               fontSize: 8.0,
//                               color: Colors.grey),
//                         )
//                       ],
//                     );
//                 }).toList(),
//               ),
//             ),
//           ),
//         ),
//         Align(
//             alignment: Alignment.bottomCenter,
//             child: Card(
//               // color: Colors.transparent,
//               child: Container(
//                   child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   ActionChip(
//                     backgroundColor: Colors.grey,
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     label: Text(
//                       "Cancel",
//                       style: widget.hintStyle,
//                     ),
//                   ),
//                   ActionChip(
//                     backgroundColor: Colors.blue,
//                     onPressed: () {},
//                     label: Text(
//                       "Register",
//                       style: widget.hintStyle.copyWith(
//                         color: Colors.white,
//                         fontSize: 13.0,
//                       ),
//                     ),
//                   ),
//                 ],
//               )),
//             )),
//       ],
//     );
//   }
// }
}
