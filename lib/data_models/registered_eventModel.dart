import 'package:flutter/material.dart';

class RegisteredEventModel {
   
  final Map<String,dynamic> cordinators;
  final String eventDesc;
  final String eventDetails;
  final String eventName ;
  final String eventRules;
  final String eventType;
  final String id;
  final String imageUrl;
  final String organizedBy;
  final String organizerMailId;
  final int fee;
  final String teamMembers;
  final String referalMailId;
  RegisteredEventModel({@required this.referalMailId,@required this.cordinators,@required this.eventDesc,@required this.eventDetails,@required this.eventName,@required this.eventRules,@required this.eventType,@required this.id,@required this.imageUrl,@required this.organizedBy,@required this.organizerMailId,@required this.fee,@required this.teamMembers});
  
}



// class RegisteredEventModel {
//   final String uid;
//   final String eventregistrationToken;
//   final String eventName;
//   final String eventOrganisedBy;
//   final String paymentStatus;
//   final DateTime timeStamp;
//   final String eventFee;
//   final String teamtype;
//   final String teamateNames;
//   final String coOrdinatorNo;
//   final String coOrdinatorName;
//   final String imageUrl;
//   final String organizerEmail;

//   RegisteredEventModel(
//       this.uid,
//       this.eventregistrationToken,
//       this.eventName,
//       this.eventOrganisedBy,
//       this.paymentStatus,
//       this.timeStamp,
//       this.eventFee,
//       this.teamtype,
//       this.teamateNames,
//       this.coOrdinatorNo,
//       this.coOrdinatorName,
//       this.imageUrl,
//       this.organizerEmail);
// }
