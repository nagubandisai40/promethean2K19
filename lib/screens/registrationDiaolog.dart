import 'package:flutter/material.dart';
import 'package:promethean_2k19/data_models/event_model.dart';

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
  final _formKey = GlobalKey<FormState>();
  bool isIndividual = true;
  String fee;

  @override
  Widget build(BuildContext context) {
    bool isIndividual = false, isTeam = false;
    int fee = 0;
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
    return Material(
      child: Container(
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
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter your Email";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    hintText: 'Enter your Email',
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.black54)),
                onSaved: (String value) {
                  setState(() {
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
                    // temp['phonenum'] = value;
                    print("Phone number:" + value);
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
                    // temp['phonenum'] = value;
                    print("Teammate Names:" + value);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormIndividual() {
    return Material(
      child: Container(
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
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter your Email";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    hintText: 'Enter your Email',
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.black54)),
                onSaved: (String value) {
                  setState(() {
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
                    // temp['phonenum'] = value;
                    print("Phone number:" + value);
                  });
                },
              ),
            ),
          ],
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
          child: Form(
            key: _formKey,
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
                      "Registration Fee " +
                          widget.event.individualFee.toString(),
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
                        onPressed: () {},
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
          child: Form(
            key: _formKey,
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
          ),
        )
      ],
    );
  }

  Widget _buildBothForm(BuildContext context) {
    print("Entered _buildBothForm");
    fee = isIndividual?widget.event.individualFee.toString():widget.event.teamFee.toString();
    print(fee);
    return Column(
      children: <Widget>[
        Card(
          elevation: 0,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                isIndividual?_buildTextFormIndividual():_buildTextFormTeam(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ActionChip(
                      backgroundColor: isIndividual ? Colors.blue : Colors.grey,
                      label: Text('Individual'),
                      onPressed: () {
                        setState(() {
                          isIndividual=!isIndividual;
                        });
                      },
                    ),
                    ActionChip(
                      backgroundColor:
                          !isIndividual ? Colors.blue : Colors.grey,
                      label: Text('Team'),
                      onPressed: () {
                        setState(() {
                          isIndividual=!isIndividual;
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
                        onPressed: () {},
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
          ),
        )
      ],
    );
  }



  Widget _buildRegistrationSection(context)
  {
      if(widget.event.eventType.toLowerCase()=="individual")
      {
        return _buildIndividualForm(context);
      }
      else if(widget.event.eventType.toLowerCase()=="team")
      {
        return _buildTeamForm(context);
      }else {
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