
import 'package:flutter/material.dart';

class Event{
  
  final Map<String,dynamic> cordinators;
  final String eventDesc;
  final String eventDetails;

  final String eventName ;
  // final int eventRegsFee;
  final String eventRules;
  final String eventType;
  final String id;
  final String organizedDept;
  final String imageUrl;
  final String organizedBy;
  // final List eventTeam;
  final String organizerMailId;
  final int individualFee;
  final int teamFee;

  Event(   
      {@required this.organizedDept,@required this.eventType,@required this.teamFee,@required this.organizerMailId,@required this.individualFee,@required this.cordinators,@required this.id, @required this.organizedBy, @required this.eventName, @required this.eventDesc, @required this.eventRules, @required this.eventDetails, @required this.imageUrl});

     List<String> getListofProperties(){
        return [this.organizedDept,this.eventName,this.eventDesc,this.eventRules,this.eventDetails]; 
    }

}

/*
  final int id;
  final String imageUrl;
  final String organizedBy;
  final String eventName ;
  final String eventTags;
  final String eventDesc;
  final String eventRules;
  //final String eventDetails;
  ///final String Individual fee
  ///final String team fee   
  final List eventCordinatorsName;
  final List eventCordinatorsContacts;

  final List eventTeam;

*/


class RegisteredEventsModel {
  final String eventName;
  final String eventOrganisedBy;
  final DateTime dateTime;
  final String status;
  final String temmates;
  final List eventCordinatorsName;
  final List eventCordinatorsContacts;
  final String registrationFee;


  RegisteredEventsModel(this.registrationFee, this.temmates,
      {this.eventName, this.eventOrganisedBy, this.dateTime, this.status, this.eventCordinatorsName, this.eventCordinatorsContacts});
//  final String organiserMail;

}


// class Event{
  
//   final Map<String,dynamic> cordinators;
//   final String eventDesc;
//   final String eventDetails;

//   final String eventName ;
//   final int eventRegsFee;
//   final String eventRules;
//   final String eventType;
//   final String id;
//   final String imageUrl;
//   final String organizedBy;
//   final List eventTeam;

//   Event(  
//       {@required this.eventType, @required this.cordinators,@required  this.eventRegsFee,@required this.id, @required this.organizedBy, @required this.eventName, @required this.eventDesc, @required this.eventRules, @required this.eventDetails, @required this.eventTeam, @required this.imageUrl, individualFee});
// }

// /*
//   final int id;
//   final String imageUrl;
//   final String organizedBy;
//   final String eventName ;
//   final String eventTags;
//   final String eventDesc;
//   final String eventRules;
//   //final String eventDetails;
//   ///final String Individual fee
//   ///final String team fee   
//   final List eventCordinatorsName;
//   final List eventCordinatorsContacts;

//   final List eventTeam;

// */


// class RegisteredEventsModel {
//   final String eventName;
//   final String eventOrganisedBy;
//   final DateTime dateTime;
//   final String status;
//   final String temmates;
//   final List eventCordinatorsName;
//   final List eventCordinatorsContacts;
//   final String registrationFee;


//   RegisteredEventsModel(this.registrationFee, this.temmates,
//       {this.eventName, this.eventOrganisedBy, this.dateTime, this.status, this.eventCordinatorsName, this.eventCordinatorsContacts});
// //  final String organiserMail;

// }

