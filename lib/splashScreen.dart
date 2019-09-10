import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promethean_2k19/common/helper.dart';
import 'package:promethean_2k19/screens/home_screen.dart';
import 'package:promethean_2k19/screens/introScreens.dart';
import 'package:promethean_2k19/screens/userprofileForm.dart';


class SplashScreen extends StatelessWidget {

  BuildContext _context;
  checkAutoVerification() {
    Future.delayed(Duration(milliseconds: 1500)).then((v) {
      Helper.autoAuthenticate().then((int isAuthenticated) {
        if (isAuthenticated==1){
          Navigator.of(_context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => HomeScreen()));
        }
        else if(isAuthenticated == 0){
          Navigator.of(_context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => UserProfileForm()));
        }
        else
          Navigator.of(_context).pushReplacement(CupertinoPageRoute(builder: (BuildContext context) => IntroScreens()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    checkAutoVerification();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: 250.0,
          child: Image.asset("assets/bvrit_vishu.png"),
        ),
      ),
    );
  }
}
