import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:promethean_2k19/common/helper.dart';
import 'package:promethean_2k19/common/messageBox.dart';
import 'package:promethean_2k19/screens/auth/phoneAuth.dart';
import 'package:promethean_2k19/screens/home_screen.dart';
import 'package:promethean_2k19/screens/profile_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GoogleSignIn _googleSignIn = new GoogleSignIn();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

 Future<Null> googleSignIn() async {
    GoogleSignInAccount googleSignInAccount = _googleSignIn.currentUser;
    googleSignInAccount = await _googleSignIn.signIn().catchError((E, R) {
      print("error $E");
    });
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
      FirebaseAuth.instance
          .signInWithCredential(GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      )).catchError((E, R) {
        print(E);
        if(E.toString().contains("PlatformException(FirebaseException, An internal error has occurred. [ 7: ], null)"))
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Something went Wrong, please check your device network connection"),));
          return;
      }).then((user) {
        if (user != null) {
          print(user.email);
          ///this set the uid and iA keys to sharedpreferences 
          Helper.finishingTaskAfterSignIn(user);
          /// next task is userInfo 
          LoadingMessageBox(context, "Fetching User Proflie", "").show();    
          Helper.checkUserInfoInDB(uid:user.uid).then((value){
             if(value){
               Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) =>HomeScreen()));
             }
             else { 
             Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => UserProfileForm()));
            }
          });
        } else {
          print("failed googleSign");
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Something thing went wrong"),));
          return null;
        }
      });
    }
    else{
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Failed to get google account"),));
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              width: double.infinity,
              // height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Color(0xFF861657),
                      Color(0xFFFFA69E),
                    ]),
              ),
            ),
            Positioned(
              top: 30.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(
                      width: MediaQuery.of(context).size.height * 0.25,
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                    child: Stack(
                      children: <Widget>[
                        Card(
                          color: Colors.transparent,
                          elevation: 13.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: Container(
                              width: MediaQuery.of(context).size.height * 0.3,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Image.asset(
                                "assets/steak_on_cooktop.jpg",
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      // color: Colors.white,
                      ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: ["SignIn with Phone", "SignIn with Google"]
                              .map((value) {
                            bool _isPhone = value.contains("Phone");
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: _isPhone
                                      ? () {
                                          Navigator.of(context).push(
                                              CupertinoPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          PhoneAuth()));
                                        }
                                      : () {
                                          print("_signIn");
                                          googleSignIn();
                                        },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: _isPhone
                                              ? Colors.blue
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      child: Center(
                                          child: Text(
                                        value,
                                        style: TextStyle(
                                          color: _isPhone
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ))),
                                ));
                          }).toList() +
                          [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.end,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        print("terms and Conditions");
                                      },
                                      child: Text.rich(TextSpan(
                                          text:
                                              " By continuning you Aggree to ®Promethene2K19  ",
                                          style: TextStyle(color: Colors.black),
                                          children: [
                                            TextSpan(
                                              text: "Terms and Conditions",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ])),
                                    ),
                                  ]),
                            )
                          ])),
            )
          ],
        ),
      ),
    );
  }
}

// Positioned(
//   child: Container(
//     child: PageView.builder(
//       itemCount: 3,
//       itemBuilder: (BuildContext context, int index) {
//         return Center(
//           child: ListTile(
//             leading: CircleAvatar(
//               col
//             ),
//             title: Text(
//               "dialog",
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         );
//       },
//     ),
//   ),
// ),

// import 'dart:async';
// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/rendering.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:promethean_2k19/authentication/logger.dart';
// import 'package:promethean_2k19/authentication/phoneauth.dart';
// import 'package:promethean_2k19/authentication/widgets/google_sign_in_btn.dart';
// import 'package:promethean_2k19/common/helper.dart';
// // import 'package:promethean_2k19/authentication/widgets/reactive_refresh_indicator.dart';
// import 'package:promethean_2k19/common/masked_text.dart';
// import 'package:promethean_2k19/common/messageBox.dart';
// import 'package:promethean_2k19/common/user.dart';
// import 'package:promethean_2k19/screens/home_screen.dart';
// import 'package:promethean_2k19/screens/userprofileForm.dart';
// import 'package:promethean_2k19/utils/sliverdelegateappbar.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// enum AuthStatus { Google_AUTH, PHONE_AUTH, SMS_AUTH, Email_SignUp, Email_Login }

// class AuthScreen extends StatefulWidget {
//   const AuthScreen({Key key}) : super(key: key);
//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   static const String TAG = "AUTH";

//   AuthStatus status;

//   // Keys
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final GlobalKey<MaskedTextFieldState> _maskedPhoneKey =
//       GlobalKey<MaskedTextFieldState>();

//   // Controllers

//   final TextEditingController smsCodeController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmController = TextEditingController();

//   // Variables

//   String _phoneNumber;
//   String _errorMessage;
//   String _verificationId;
//   Timer _codeTimer;
//   // Size _deviceSize;

//   bool setLoadingto = false;

//   //email validation

//   String errorLabel = '';

//   bool isError = false;
//   bool pass, emailbool, conformpass;

//   bool _isRefreshing = false;
//   bool _codeTimedOut = false;
//   bool _codeVerified = false;
//   bool _optionSelected = true;
//   Duration _timeOut = const Duration(seconds: 1);

//   // Firebase
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   //SharedPreferences ..
//   Future<SharedPreferences> _sharedPreferences =
//       SharedPreferences.getInstance();

//   /// tpes of users for Verification.
//   GoogleSignInAccount _googleUser;
//   FirebaseUser _firebaseUser;

//   /// Email_Authentication has two ways to go
//   // Styling

//   final labeldecorationStyle = TextStyle(color: Colors.white, fontSize: 16.0);
//   final hintStyle = TextStyle(color: Colors.white54);
//   final desctitleDecorationStyle =
//       TextStyle(color: Colors.black, fontSize: 16.0);

//   //

//   @override
//   void dispose() {
//     _codeTimer?.cancel();
//     super.dispose();
//   }

//   // async

//   Future<Null> _updateRefreshing(bool isRefreshing) async {
//     Logger.log(TAG, message: "Setting _isRefreshing ($_isRefreshing) to $isRefreshing");
//     if (_isRefreshing) {
//       setState(() {
//         this._isRefreshing = false;
//       });
//     } else {
//       setState(()
//       {
//         this._isRefreshing = isRefreshing;
//       });
//     }
//   }

//   /// this Function : is indication for user to get the errors if any.
//   _showErrorSnackbar(String message) {
//     _updateRefreshing(false);
//     _scaffoldKey.currentState.showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   ///Future that runs for PHONE_AUTH.
//   Future<Null> _submitPhoneNumber() async {
//     final error = _phoneInputValidator();
//     if (error != null) {
//       setState(() {
//         _errorMessage = error;
//       });
//       return null;
//     } else {
//       setState(() {
//         _errorMessage = null;
//       });
//       final result = await _verifyPhoneNumber();
//       Logger.log(TAG, message: "Returning $result from _submitPhoneNumber");
//       return result;
//     }
//   }

//   String get phoneNumber {
//     try {
//       String unmaskedText = _maskedPhoneKey.currentState?.unmaskedText;
//       // Logger.log(TAG, message: "Got phone number as: ${this.phoneNumber}");

//       if (unmaskedText != null) _phoneNumber = "+91 $unmaskedText".trim();
//     } catch (error) {
//       Logger.log(TAG,
//           message: "Couldn't access state from _maskedPhoneKey: $error");
//     }
//     return _phoneNumber;
//   }

//   closeLoadingDialog(){
//     Navigator.of(context).pop();
//   }

//   showLoading(){
//       LoadingMessageBox(context, "Loading ", "").show();
//   }

//   toogleLoading(){
//     if(setLoadingto)
//     showLoading();
//     else
//     closeLoadingDialog();
//   }

// //phone Verifiation
//   /// Funtion for : PhoneVerificationFailed
//   verificationFailed(AuthException authException) {
//       // _showErrorSnackbar("Auto Verification time Out Please Enter OTP manually");
//     print("Failied called");
//     // _updateRefreshing(false);
//     String error = "We couldn't verify your code for now, please try again!";
//     if (authException.code.contains(
//         "quotaExceeded"))
//       _showErrorSnackbar(authException.code);
//     //  if (authException.code.contains(
//     //     "quotaExceeded, message: We have blocked all requests from this device due to unusual activity. Try again later"))
//     //   _showErrorSnackbar(authException.code);

//     if (authException.code
//         .contains("The format of the phone number provided is incorrect"))
//       _showErrorSnackbar(
//           "The format of the phone number provided is incorrect.");

//     else {
//       _showErrorSnackbar(error);
//     }
//     Logger.log(TAG,message:'onVerificationFailed, code: ${authException.code}, message: ${authException.message}');
//   }

//   codeSent(String verificationId, [int forceResendingToken]) {
//     print("OnCode Sent ");
//     PhoneAuthentication.verificationId = verificationId;
//     Logger.log(TAG,message:"Verification code sent to number ${phoneNumberController.text}");
//     _codeTimer = new Timer(_timeOut, () {

//         print("ontime Out fired ");
//     });
//     setState(() {
//       this.status = AuthStatus.SMS_AUTH;
//       Logger.log(TAG, message: "Changed status to $status 344");
//     });
//   }

//   ///Function for : PhoneCodeAutoRetrievalTimeout

//   codeAutoRetrievalTimeout(String verificationId) {
//     print(setLoadingto);

//     print("called Auto Code Retrival TimeOut");
//     Logger.log(TAG, message: "onCodeTimeout");
//     _updateRefreshing(false);
//     setState(() {
//       // setLoadingto =false;
//       // toogleLoading();
//       print(setLoadingto);
//       PhoneAuthentication.verificationId = verificationId;
//       this._codeTimedOut = true;
//     });
//   }

//   /// whole Logic of PHONE_AUTH from Firebase Auth/..

//   Future<Null> _verifyPhoneNumber() async {
//     // print(setLoadingto);

//     Logger.log(TAG, message: "Got phone number as: ${this.phoneNumber}");
//     PhoneAuthentication.phoneNo = this.phoneNumber;
//     PhoneAuthentication.autoRetrieve = codeAutoRetrievalTimeout;
//     PhoneAuthentication.smsCodeSent = codeSent;
//     PhoneAuthentication.timeOut = _timeOut;
//     PhoneAuthentication.verifiedSuccess = _linkWithPhoneNumber;
//     PhoneAuthentication.veriFailed = verificationFailed;
//     PhoneAuthentication.verifyPhone();

//     Logger.log(TAG, message: "Returning null from _verifyPhoneNumber");
//     return null;
//   }

//   ///runs the manual OTP verification

//   Future<Null> _submitSmsCode() async {

//       print("Helllo ");
//       Logger.log(TAG,
//             message:
//                 "_linkWithPhoneNumber called with ${smsCodeController.text} and verification ID $_verificationId ");
//         // var authcredetial = ;
//         print("Authenticating manually getting user");
//         _firebaseUser = await _auth.signInWithCredential(PhoneAuthProvider.getCredential(
//             verificationId: this._verificationId,
//             smsCode: this.smsCodeController.text))
//             .catchError((error) {

//           print("error occured $error");
//         });
//         print("Authentication successfull");

//         setState(() {
//           this._codeVerified = true;
//         });

//         // _showErrorSnackbar("verified phone with firebase user ${_auth.currentUser()}");
//         // setLoadingto = false;
//         // toogleLoading();
//         // print("set isLoading to false and removed Loading");

//         print("getting linknig with phone Number line 408");
//         _linkWithPhoneNumber(
//           PhoneAuthProvider.getCredential(
//             smsCode: smsCodeController.text,
//             verificationId: _verificationId,
//           ),
//         );
//       // }

//   }

//   Future<void> _linkWithPhoneNumber(AuthCredential credential) async {
//     final errorMessage = "We couldn't verify your code, please try again!";
// //    print("${_firebaseUser.displayName} is the user name ");
//       print("this linkwithphone caled");
//     try {
//       PhoneAuthentication.smsCode = this.smsCodeController.text;
//       // _updateRefreshing(true);

//       _firebaseUser = await PhoneAuthentication.phonesignIn(credential);

//       // _firebaseUser = await _auth.signInWithCredential(credential);
//     } catch (e) {
//       print("Exception occured in linkwithPhonenumber $e");
//     }

// //    print("${_firebaseUser.displayName}");

//     try {
//       print("tried 437");
//       this._codeVerified = await _onCodeVerified(_firebaseUser);
//       if (this._codeVerified) {
//         print("Phone number is successfully authenticated.");
//         _showErrorSnackbar(
//             "Successfull phone Verified ${_firebaseUser.phoneNumber} .");
//         _finishSignIn(_firebaseUser);
//       } else {
//         print("line 445");
//         _showErrorSnackbar(errorMessage);
//       }
//     } catch (e) {
//       print("This is exception occured in the second try block $e");
//     }
//   }

//   ///used as phone user validator...

//   Future<bool> _onCodeVerified(FirebaseUser user) async {
//     final isUserValid = (user != null &&
//         (user.phoneNumber != null && user.phoneNumber.isNotEmpty));
//     if (isUserValid) {
//       setState(() {
//         Logger.log(TAG, message: "Changed status to $status");
//       });
//     } else {
//       _showErrorSnackbar("We couldn't verify your code, please try again!");
//     }
//     return isUserValid;
//   }

//   Future<Null> _finishSignIn(FirebaseUser user) async {

//     SharedPreferences prefs = await _sharedPreferences;
//     // widget.model.authenticatedUser = new User(uid: user.uid, accessToken: "");
//     prefs.setBool('_isAuthenticated', true);
//     prefs.setString('uid', user.uid);
//     print("${user.uid}");
//     setState(() {

//       new LoadingMessageBox(context, 'Fetching User Profile', '').show();
//     });
//     try {
//       var response = await http.get(
//           "https://promethean2k19-68a29.firebaseio.com/users/${user.uid}/userInfo.json");

//       print("Stattuxs code ${response.statusCode}");
//       if (response.statusCode == 200) {
//         if (json.decode(response.body) != null) {
//           print(json.decode(response.body).toString());
//           print("user Information  Entered by User to Firebase so setting USerInfo to true");
//           prefs.setBool("UserInfoSet", true);
//           Helper.authenticatedUser = new User(uid: prefs.get("isAuthenticated"),);
//           Navigator.of(context).pop();
//           Navigator.of(context).pushReplacement(CupertinoPageRoute(
//               builder: (context) => HomeScreen()));
//         } else {
//           print(
//               "user Information not Entered by User to Firebase so settin USerInfo to false");
//           prefs.setBool("UserInfoSet", false);

//           Navigator.of(context).pop();

//           Navigator.of(context).pushReplacement(CupertinoPageRoute(
//               builder: (context) => UserProfileForm(
//                       )));
//         }
//       } else {
//         print("Error Ocurred");
//       }
//     } catch (e) {
//       print("Exception is ftching userDetails $e");
//       Navigator.of(context).pop();
//       _showErrorSnackbar("Please check your device network Connection");
//       SharedPreferences prefs = await _sharedPreferences;
//       prefs.clear();
//       return null;
//     }
//   }

//   Widget _buildSocialLoginBody() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           // SizedBox(height: 24.0),
//           GoogleSignInButton(
//             onPressed: () {
//               setState(() {
//                 status = AuthStatus.Google_AUTH;
//                 _signIn();
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPhoneAuthButton() {
//     return _optionSelected
//         ? RaisedButton(
//             splashColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             color: Colors.white,
//             elevation: 3.0,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Icon(Icons.phone_iphone, color: Colors.green),
//                 SizedBox(
//                   width: 17.0,
//                 ),
//                 Text(
//                   "Sign in with Phone",
//                   style: TextStyle(fontSize: 15.0, color: Colors.blue),
//                 ),
//               ],
//             ),
//             onPressed: () {
//               setState(() {
//                 status = AuthStatus.PHONE_AUTH;
//                 _optionSelected = false;
//                 // _updateRefreshing(false);
//               });
//             },
//           )
//         : Container();
//   }

//   Widget _buildConfirmInputButton() {
//     final theme = Theme.of(context);
//     return Container(
//       decoration: BoxDecoration(
//           border: Border.all(
//         color: Colors.lightBlue,
//         width: 1.5,
//       )),
//       child: IconButton(
//         icon: Icon(Icons.check),
//         color: theme.accentColor,
//         disabledColor: theme.buttonColor,
//         onPressed: () {
//           String error = _smsInputValidator();
//           if(error!=null){
//             _showErrorSnackbar(error);
//           }
//           else{
//             setLoadingto = true;
//             toogleLoading();
//             _submitSmsCode();
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildPhoneAuthBody() {
//     return Container(
//       height: MediaQuery.of(context).size.width * 0.5,
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.max,
//           children: <Widget>[
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
//               child: Text(
//                 "We'll send an SMS message to verify your identity, please enter your number right below!",
//                 style: desctitleDecorationStyle,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Flexible(
//                 flex: 2,
//                 child: SizedBox(
//                   height: 10.0,
//                 )),
//             Flexible(
//               flex: 1,
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 child: MaskedTextField(
//                   key: _maskedPhoneKey,
//                   mask: "xxxxx-xxxxx",
//                   keyboardType: TextInputType.number,
//                   maskedTextFieldController: phoneNumberController,
//                   maxLength: 11,
//                   onSubmitted: (text) {
//                     print("here");
//                     String error = _phoneInputValidator();
//                     if (error == null) {
//                      setState(() {
//                       // setLoadingto =true;
//                       //  toogleLoading();
//                        _submitPhoneNumber();
//                      });
//                     } else
//                       setState(() {
//                         _errorMessage = error;
//                       });
//                   },
//                   style: Theme.of(context)
//                       .textTheme
//                       .subhead
//                       .copyWith(fontSize: 18.0, color: Colors.black),
//                   inputDecoration: InputDecoration(
//                     isDense: false,
//                     enabled: this.status == AuthStatus.PHONE_AUTH,
//                     counterText: "",
//                     // labelText: " ",
//                     // labelStyle:
//                     //     labeldecorationStyle.copyWith(color: Colors.grey),
//                     hintText: "Enter PhoneNumber",
//                     hintStyle: hintStyle.copyWith(color: Colors.green),
//                     errorText: _errorMessage,
//                     errorStyle: TextStyle(color: Colors.red),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSmsCodeInput() {
//     final enabled = this.status == AuthStatus.SMS_AUTH;
//     return ClipRRect(
//       borderRadius:
//           BorderRadius.circular(MediaQuery.of(context).size.width * 0.02),
//       child: Container(
//         color: Colors.green,
//         child: TextField(
//           keyboardType: TextInputType.number,
//           enabled: enabled,
//           textAlign: TextAlign.center,
//           controller: smsCodeController,
//           maxLength: 6,
//           onSubmitted: (text) => _updateRefreshing(true),
//           style: Theme.of(context).textTheme.subhead.copyWith(
//                 fontSize: 32.0,
//                 color: enabled ? Colors.white : Theme.of(context).buttonColor,
//               ),
//           decoration: InputDecoration(
//             counterText: "",
//             enabled: enabled,
//             hintText: "--- ---",
//             hintStyle: hintStyle.copyWith(fontSize: 42.0),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildResendSmsWidget() {
//     return InkWell(
//       onTap: () async {
//         if (_codeTimedOut) {
//           await _verifyPhoneNumber();
//         } else {
//           _showErrorSnackbar("You can't retry yet!");
//         }
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: RichText(
//           textAlign: TextAlign.center,
//           text: TextSpan(
//             text: "If your code does not arrive in 1 minute, touch",
//             style: labeldecorationStyle.copyWith(
//               fontSize: 13.0,
//               color: Colors.lightBlue,
//             ),
//             children: <TextSpan>[
//               TextSpan(
//                 text: " here",
//                 style: TextStyle(
//                   fontSize: 16.0,
//                   color: Colors.blue,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   bool emailvalidator(String email) {
//     if (email.isEmpty ||
//         !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
//             .hasMatch(email)) {
//       print("enterd flase1 ");
//       return false;
//     }
//     if (email.contains("@gmail.com") || email.contains("@bvrit.ac.in")) {
//       print("Contains @gmail.com @bvrit.ac.in");
//       return true;
//     } else
//       print("Enterd false 2");
//     return false;
//   }

//   bool passwordValidator(String password) {
//     if (password.length < 8 || password.isEmpty) {
//       return false;
//     } else if (password.contains(" ")) {
//       print("Password contains space");
//       return false;
//     } else
//       return true;
//   }

//   _buildEmailLoginBody() {
//     return Container(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Container(
//             child: Text(
//               status == AuthStatus.Email_Login ? 'Login' : 'SignUp',
//               textScaleFactor: 2.0,
//               style: TextStyle(
//                 color: status == AuthStatus.Email_Login
//                     ? Colors.blue
//                     : Colors.green,
//               ).copyWith(fontWeight: FontWeight.w600),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 30.0),
//             child: Column(
//               children: <Widget>[
//                 CupertinoTextField(
//                   onChanged: (String s) {
//                     print("$s");
//                     print("${emailController.text}");
//                   },
//                   controller: emailController,
//                   prefix: Icon(
//                     CupertinoIcons.mail_solid,
//                     color: CupertinoColors.lightBackgroundGray,
//                     size: 28.0,
//                   ),
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
//                   clearButtonMode: OverlayVisibilityMode.editing,
//                   keyboardType: TextInputType.emailAddress,
//                   autocorrect: false,
//                   decoration: BoxDecoration(
//                     border: Border(
//                         bottom: BorderSide(
//                             width: 0.0, color: CupertinoColors.inactiveGray)),
//                   ),
//                   placeholder: 'Email',
//                 ),
//                 CupertinoTextField(
//                   controller: passwordController,
//                   prefix: Icon(
//                     Icons.lock,
//                     color: CupertinoColors.lightBackgroundGray,
//                     size: 28.0,
//                   ),
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
//                   clearButtonMode: OverlayVisibilityMode.editing,
//                   autocorrect: false,
//                   decoration: BoxDecoration(
//                     border: Border(
//                         bottom: BorderSide(
//                             width: 0.0, color: CupertinoColors.inactiveGray)),
//                   ),
//                   placeholder: 'Password',
//                 ),
//               ],
//             ),
//           ),
//           status == AuthStatus.Email_SignUp
//               ? Container(
//                   margin: EdgeInsets.symmetric(horizontal: 30.0),
//                   child: CupertinoTextField(
//                     controller: confirmController,
//                     prefix: Icon(
//                       Icons.lock,
//                       color: CupertinoColors.lightBackgroundGray,
//                       size: 28.0,
//                     ),
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
//                     clearButtonMode: OverlayVisibilityMode.editing,
//                     autocorrect: false,
//                     decoration: BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(
//                               width: 0.0, color: CupertinoColors.inactiveGray)),
//                     ),
//                     placeholder: 'Confirm Password',
//                   ),
//                 )
//               : Container(),
//           SizedBox(
//             height: 20.0,
//           ),
//           isError
//               ? Text(
//                   errorLabel,
//                   style: TextStyle(color: Colors.red, fontSize: 15.0),
//                 )
//               : Container(),
//           isError
//               ? SizedBox(
//                   height: 10.0,
//                 )
//               : SizedBox(
//                   height: 1.0,
//                 ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: CupertinoButton.filled(
//               child:
//                   Text(status == AuthStatus.Email_Login ? "Login" : "SignUp"),
//               onPressed: () {
//                 FocusScope.of(context).requestFocus(new FocusNode());
//                 setState(() {
//                   if (status == AuthStatus.Email_Login) {
//                     emailbool = emailvalidator(emailController.text);
//                     pass = passwordValidator(passwordController.text);
//                     if (!pass || !emailbool) {
//                       if (!emailbool) {
//                         setState(() {
//                           isError = true;
//                           errorLabel = "Invalid Email";
//                         });
//                       } else if (!pass) {
//                         setState(() {
//                           isError = true;
//                           errorLabel = "Invalid password";
//                         });
//                       }
//                     } else {
//                       setState(() {
//                         isError = false;
//                         setLoadingto = true;
//                         toogleLoading();
//                         print("jjk");
//                         emailvarification(emailController.text, passwordController.text);
//                         // _updateRefreshing(true);
//                       });
//                     }
//                   } else if (status == AuthStatus.Email_SignUp) {
//                     pass = passwordValidator(passwordController.text);
//                     emailbool = emailvalidator(emailController.text);
//                     conformpass =
//                         (passwordController.text == confirmController.text);
//                     print(
//                         "email bool $emailbool pass bool $pass conform pass $conformpass");
//                     if (passwordController.text.isEmpty ||
//                         emailController.text.isEmpty) {
//                       setState(() {
//                         errorLabel = "Email or password is empty !!";
//                         isError = true;
//                       });
//                     } else if (!emailbool || !pass) {
//                       if (!emailbool) {
//                         setState(() {
//                           errorLabel = "Invalid Email !!";
//                           isError = true;
//                         });
//                       } else if (!pass) {
//                         setState(() {
//                           errorLabel = "Invalid Password !!";
//                           isError = true;
//                         });
//                       }
//                     } else if (!conformpass) {
//                       setState(() {
//                         errorLabel = "Confirm Password not Matched.";
//                         isError = true;
//                       });
//                     } else {
//                       setState(() {
//                         isError = false;
//                       });
//                       print("email signUp");
//                       setLoadingto = true;
//                       toogleLoading();
//                         emailvarification(emailController.text, passwordController.text);
//                       // _updateRefreshing(true);
//                     }
//                   }
//                 });
//               },
//             ),
//           ),
//           SizedBox(
//             height: 10.0,
//           ),
//           InkWell(
//             onTap: () {
//               setState(() {
//                 status == AuthStatus.Email_Login
//                     ? status = AuthStatus.Email_SignUp
//                     : status = AuthStatus.Email_Login;
//                 isError = false;
//                 errorLabel = "";
//               });
//             },
//             child: Text.rich(
//               TextSpan(
//                   text: status == AuthStatus.Email_Login
//                       ? "No Account Register "
//                       : "Already had an Account Press  ",
//                   style: TextStyle(
//                     color: Colors.lightBlue,
//                     fontSize: 17.0,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: "Here.",
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontSize: 20.0,
//                       ),
//                     ),
//                   ]),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildSmsAuthBody() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
//           child: Text(
//             "Enter Verification code here.",
//             style: labeldecorationStyle.copyWith(
//                 color: Colors.lightBlue, fontSize: 23.0),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 64.0),
//           child: Flex(
//             direction: Axis.horizontal,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Flexible(flex: 5, child: _buildSmsCodeInput()),
//               Flexible(flex: 2, child: _buildConfirmInputButton())
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: _buildResendSmsWidget(),
//         ),
//       ],
//     );
//   }

//   String _phoneInputValidator() {
//     if (phoneNumberController.text.isEmpty) {
//       // _updateRefreshing(false);
//       print("This number is empty");
//       return "Your phone number can't be empty!";
//     } else if (phoneNumberController.text.length != 11) {
//       print("This number is invalid");
//       // _updateRefreshing(false);
//       return "This phone number is invalid!";
//     }
//     return null;
//   }

//   String _smsInputValidator() {
//     if (smsCodeController.text.isEmpty) {
//       return "Your verification code can't be empty!";
//     } else if (smsCodeController.text.length < 6) {
//       return "This verification code is invalid!";
//     }
//     return null;
//   }

//   Widget _buildBody() {
//     Widget body;
//     switch (this.status) {
//       case AuthStatus.Google_AUTH:
//         body = Container();
//         break;
//       case AuthStatus.PHONE_AUTH:
//         body = Align(
//           alignment: Alignment.bottomCenter,
//           child: _buildPhoneAuthBody(),
//         );
//         break;
//       case AuthStatus.SMS_AUTH:
//         body = _buildSmsAuthBody();
//         break;
//       case AuthStatus.Email_SignUp:
//       case AuthStatus.Email_Login:
//         body = _buildEmailLoginBody();
//         break;
//       default:
//         body = Container();
//     }
//     return body;
//   }

//   // Future<Null> _onRefresh() async {
//   //   switch (this.status) {
//   //     case AuthStatus.Google_AUTH:
//   //       return await _signIn();
//   //       break;
//   //     case AuthStatus.PHONE_AUTH:
//   //       return await _submitPhoneNumber();
//   //       break;
//   //     case AuthStatus.SMS_AUTH:
//   //       return await _submitSmsCode();
//   //       break;
//   //     case AuthStatus.Email_SignUp:
//   //     case AuthStatus.Email_Login:
//   //       emailvarification(emailController.text, passwordController.text);
//   //       break;
//   //   }
//   // }

//   static final double _initialToolbarHeight = 300;
//   static final double _maxSizeFactor = 1.5; // image max size will 130%
//   static final double _transformSpeed = 0.001; // 0.1 very fast,   0.001 slow
//   ScrollController _controller;
//   double _factor = 1;
//   double _opacity = 1;
//   double _expandedToolbarHeight = _initialToolbarHeight;

//   _scrollListener() {
//     // print(_controller.offset);
//     // print("factor $_factor");
//     if (_controller.offset < 0) {
//       _factor = 1 + _controller.offset.abs() * _transformSpeed;
//       _factor = _factor.clamp(1, _maxSizeFactor);
//       _opacity = 1;
//       _expandedToolbarHeight =
//           _initialToolbarHeight + _controller.offset.abs(); //
//     } else {
//       _opacity = 1 - _controller.offset.abs() * _transformSpeed;
//       _opacity = _factor.clamp(0.0, 1.0);
//       _factor = 1 - _controller.offset.abs() * 0.006;
//       _factor = _factor.clamp(0.5, _maxSizeFactor);

//       _expandedToolbarHeight = _initialToolbarHeight; //
//     }
//     setState(() {});
//   }

//   @override
//   void initState() {
//     _controller = ScrollController();
//     _controller.addListener(_scrollListener);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).requestFocus(new FocusNode());
//         },
//         child: CustomScrollView(
//           physics: const ClampingScrollPhysics(),
//           controller: _controller,
//           slivers: <Widget>[
//             SliverPersistentHeader(
//               floating: false,
//               pinned: true,
//               delegate: SliverAppBarDelegate(
//                 minHeight: 300,
//                 maxHeight: 300,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Transform.scale(
//                       scale: _factor,
//                       child: ConstrainedBox(
//                         constraints: BoxConstraints.expand(
//                           width: 250.0,
//                           height: 250.0,
//                         ),
//                         child: Stack(
//                           children: <Widget>[
//                             Card(
//                               color: Colors.transparent,
//                               elevation: 13.0,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(2.0),
//                                 child: Container(
//                                   width: 245.0,
//                                   height: 245.0,
//                                   child: Image.asset(
//                                     "assets/steak_on_cooktop.jpg",
//                                     fit: BoxFit.cover,
//                                     // filterQuality: FilterQuality.high,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SliverList(
//               delegate: SliverChildListDelegate([
//                 Container(
//                   child: Container(
//                     child: Column(
//                       children: <Widget>[
//                         _optionSelected
//                             ? _getOptionPanel()
//                             : Align(
//                                 alignment: Alignment.centerRight,
//                                 child: CupertinoButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         _optionSelected = true;
//                                         status = null;
//                                       });
//                                     },
//                                     child: Text("back")),
//                               ),
//                         _buildBody(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Column _getOptionPanel() {
//     return Column(
//       children: <Widget>[
//         SizedBox(
//           height: 50.0,
//         ),
//         _buildPhoneAuthButton(),
//         _buildSocialLoginBody(),
//         _buildEmailverificationButton(),
//       ],
//     );
//   }

//   Widget _buildEmailverificationButton() {
//     return _optionSelected
//         ? RaisedButton(
//             splashColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             color: Colors.white,
//             elevation: 3.0,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Icon(
//                   Icons.mail_outline,
//                   color: Colors.red,
//                 ),
//                 SizedBox(
//                   width: 23.0,
//                 ),
//                 Text(
//                   "Sign in with Email",
//                   style: TextStyle(fontSize: 15.0, color: Colors.blue),
//                 ),
//               ],
//             ),
//             onPressed: () {
//               setState(() {
//                 status = AuthStatus.Email_Login;
//                 _optionSelected = false;
//                 // _updateRefreshing(true);ṁ
//               });
//             },
//           )
//         : Container();
//   }
// }

// class GoogleAuth extends StatefulWidget {
//   final GlobalKey<ScaffoldState> scaffoldKey;

//   const GoogleAuth({Key key, this.scaffoldKey}) : super(key: key);
//   @override
//   _GoogleAuthState createState() => _GoogleAuthState();
// }

// class _GoogleAuthState extends State<GoogleAuth> {

//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   // _showErrorSnackbar(String message) {
//   //    widget.scaffoldKey.currentState.showSnackBar(
//   //     SnackBar(content: Text(message)),
//   //   );
//   // }

//   Future<Null> _signIn() async {

//     GoogleSignInAccount googleCurrentAccount = _googleSignIn.currentUser;

//     Logger.log("Gmail SignIn", message: "Just got user as: $googleCurrentAccount");

//     final onError = (exception, stacktrace) {
//       Logger.log("AuthGmail", message: "Error from _signIn: $exception");
//       if (exception.toString().contains(
//           "sign_in_failed, com.google.android.gms.common.api.ApiException: 7")) {
//         AuthHelper ("Please Check your Network Connection.");
//       } else {
//         _showErrorSnackbar("Something went wrong Please try again !!");
//       }
//     };

//     if (googleCurrentAccount == null) {
//       try {
//         print(
//             "as curent user is null we go with signmethod and get google acc");
//         googleCurrentAccount = await _googleSignIn.signIn().catchError(onError);
//       } catch (e) {
//         print("Exception  occured in sign in $e");
//       }
//       Logger.log("Gmail SignIN", message: "Received $googleCurrentAccount");

//       if (googleCurrentAccount != null) {
//         ///now authentcating with the [googleCurrentAccount]
//          googleCurrentAccount = await _googleSignIn.signIn().catchError(onError);
//        final GoogleSignInAuthentication googleAuth =
//             await googleCurrentAccount.authentication;
//         Logger.log("Gmail SignIN", message: "Added googleAuth: $googleAuth");

//         ///verifying the credentials which is the last step of verifycation.
//         googleCurrentAccount = await _googleSignIn.signIn().catchError(onError);
//        final GoogleSignInAuthentication googleAuth =
//             await googleCurrentAccount.authentication;
//         _firebaseUser = await _auth
//             .signInWithCredential(GoogleAuthProvider.getCredential(
//               accessToken: googleAuth.accessToken,
//               idToken: googleAuth.idToken,
//             ))
//             .catchError(onError);
//       } else {
//         Logger.log("Gmail SignIN", message: "got account null so discarded  is the name ");
//         _showErrorSnackbar("Falied to get the account");
//       }
//     }

//     if (googleCurrentAccount != null) {
//       _googleUser = googleCurrentAccount;
//       setState(() {
//         // this.status = AuthStatus.PHONE_AUTH;
//         Logger.log("Gmail SignIN", message: "Changed status to $status");
//       });
//       _showErrorSnackbar("Successfully signed in with ${_googleUser.email}");
//       _finishSignIn(_firebaseUser);
//       return null;
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           // SizedBox(height: 24.0),
//           GoogleSignInButton(
//             onPressed: () {
//               setState(() {
//                 status = AuthStatus.Google_AUTH;
//                 _signIn();
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PhoneAuth extends StatefulWidget {
//   @override
//   _PhoneAuthState createState() => _PhoneAuthState();
// }

// class _PhoneAuthState extends State<PhoneAuth> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           FlutterLogo(),

//         ],
//       ),
//     );
//   }
// }

// class EmailAuth  extends StatefulWidget {

//     final GlobalKey<ScaffoldState> scaffoldKey;

//   EmailAuth({this.scaffoldKey});

//   @override
//   _EmailAuthState createState() => _EmailAuthState();
// }

// class _EmailAuthState extends State<EmailAuth> {
//     _showErrorSnackbar(String message) {
//      widget.scaffoldKey.currentState.showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   emailvarification(String email, String password) {
//     final onError = (exception, stacktrace) {
//       String message;
//       if (exception.toString().contains("ERROR_NETWORK_REQUEST_FAILED")) {
//         message = "Please check your device Internet connection.";
//         _showErrorSnackbar("$message");
//       } else if (exception.toString().contains("ERROR_USER_NOT_FOUND")) {
//         message = "User with these Credentials does not exist. Please Sign Up";
//         _showErrorSnackbar("$message");

//           passwordController.clear();
//           status = AuthStatus.Email_SignUp;
//       } else if (exception.toString().contains("ERROR_EMAIL_ALREADY_IN_USE")) {
//         message = "${emailController.text} is Already in use.";
//         _showErrorSnackbar("$message");

//           passwordController.clear();
//           status = AuthStatus.Email_Login;
//       } else if (exception.toString().contains("ERROR_WRONG_PASSWORD")) {
//         message = "Incorrect Password.";
//         _showErrorSnackbar("$message");
//       } else {
//         message = exception.toString();
//         _showErrorSnackbar("$message");
//       }
//     };

//     if (status == AuthStatus.Email_SignUp) {
//       ///creating new User
//       _auth.createUserWithEmailAndPassword(email: email, password: password)
//           .then((FirebaseUser user) {
//         if (user.uid != null && user != null) {
//           setLoadingto=false;
//           toogleLoading();
//           _showErrorSnackbar("Successfully created user ${user.email}");
//           print("Provider id : ${user.providerId}\n");
//          }
//         _firebaseUser = user;
//         _finishSignIn(_firebaseUser).catchError((error) {
//           // Navigator.of(context).pop();
//           return null;
//         });
//       }).catchError(onError);
//     } else if (status == AuthStatus.Email_Login) {
//       /// login the user with email and password.
//       ///

//       _auth
//           .signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       )
//           .then((FirebaseUser user) async {
//         if (user.uid != null && user != null) {
//           _showErrorSnackbar(" Login Successfull user with ${user.email}");
//           // print("Provider id : ${user.providerId}\n");
//           String s = await user.getIdToken();
//           print("$s");
//           // refresh: true
//         }
//         _firebaseUser = user;
//         _updateRefreshing(false);

//         try {
//           return _finishSignIn(_firebaseUser);
//         } catch (e) {
//           Navigator.of(context).pop();
//           return null;
//         }
//       }).catchError(onError);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return null;
//   }
// }

// class AuthHelper
// {
//      static GlobalKey<ScaffoldState> scaffoldKey;

//  static showErrorSnackbar(String message) {
//       scaffoldKey.currentState.showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

// }
