import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:promethean_2k19/common/user.dart';
import 'package:promethean_2k19/utils/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Helper {
  static Future<SharedPreferences> getpreferences() async =>
      await SharedPreferences.getInstance();
  static Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();

  static User authenticatedUser;

  static Future<int> autoAuthenticate() async {
    SharedPreferences _prefs = await _sharedPreferences;

    bool _isAuthenticated = _prefs.get("iA");
    print(
        "_is Authenticated from Helper $_isAuthenticated is persistent Storage");
    if (_isAuthenticated != null) {
      authenticatedUser = new User(uid: _prefs.get("uid"));
      print("autheticated User uid : ${authenticatedUser.uid}");
      bool isUserInfo = _prefs.getBool("UIS");
      if(isUserInfo){
        // "isAuthisUserSet"
        return 1;
      }
      else {
        // "isAuthNoUserSet"
        return 0;
      }
    } else {
      authenticatedUser = new User(uid: "");
      // "NoAuthNoUserSet"
      return -1;
    }
  }

  static void setauthenticatedUser({String uid}) {
    authenticatedUser = new User(uid: uid);
  }

  static finishingTaskAfterSignIn(FirebaseUser user) async {
    print("task after signin");
    SharedPreferences _prefs = await _sharedPreferences;
    _prefs.setString("uid", user.uid);
    _prefs.setBool("iA", true);
  }

  static finishUserInfoSet({bool isUserSet}) async {
    print("seting UIS to $isUserSet");
    SharedPreferences _prefs = await _sharedPreferences;
    _prefs.setBool("UIS", isUserSet);

  }

/*
    as sharedprefes might take sapce insotreing key and values so reduced follwing
    as:   UserInfoSet -------   UIS
          uid ---------------   uid
          isAuthenticated ----- iA
*/
  static Future<bool> checkUserInfoInDB({String uid}) async {
    bool out;
    await http.get(Urls.getUsers+"/$uid/userInfo.json").then((http.Response response) {
      if (json.decode(response.body)!= null) {
        print(json.decode(response.body).toString()+"is the response body");
        Helper.finishUserInfoSet(isUserSet: true);
        out = true;
      } else{
        Helper.finishUserInfoSet(isUserSet: false);
        out = false;
      }
    });
    return out;
  }
}
